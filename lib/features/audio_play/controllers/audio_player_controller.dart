import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/features/audio_play/repositories/audio_repository.dart';
import 'package:golidoli_app/utils/helpers.dart';

class AudioPlayerController extends GetxController {
  final AudioRepository _repository = AudioRepository();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Rxn<AudioStoryModel> story = Rxn<AudioStoryModel>();
  final RxInt currentEpisodeIndex = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isLoadingAudio = false.obs;
  final RxDouble currentPosition = 0.0.obs; // in seconds
  final RxDouble totalDuration = 0.0.obs; // in seconds
  final RxDouble seekValue = 0.0.obs;
  final RxString currentStreamingUrl = ''.obs;

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _completeSub;
  Timer? _progressSaveTimer;

  @override
  void onInit() {
    super.onInit();
    _setupAudioListeners();
    _handleArguments();
  }

  @override
  void onClose() {
    _saveProgress();
    _progressSaveTimer?.cancel();
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _completeSub?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.onClose();
  }

  void _setupAudioListeners() {
    // Position listener
    _posSub = _audioPlayer.onPositionChanged.listen((pos) {
      currentPosition.value = pos.inSeconds.toDouble();
      seekValue.value = pos.inSeconds.toDouble();
    });

    // Duration listener
    _durSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (dur.inSeconds > 0) {
        totalDuration.value = dur.inSeconds.toDouble();
      }
    });

    // State listener
    _stateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying.value = (state == PlayerState.playing);
    });

    // Completion listener
    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      _onEpisodeCompleted();
    });

    // Periodic Progress Saver (Every 10 seconds)
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (isPlaying.value) {
        _saveProgress();
      }
    });
  }

  Future<void> _handleArguments() async {
    final args = Get.arguments;
    int initialEpisodeIndex = 0;
    int initialProgressSeconds = 0;

    if (args is AudioStoryModel) {
      story.value = args;
    } else if (args is Map) {
      if (args['story'] is AudioStoryModel) {
        story.value = args['story'] as AudioStoryModel;
      }
      if (args['episodeIndex'] != null) {
        initialEpisodeIndex = args['episodeIndex'] as int;
      }
      if (args['progressSeconds'] != null) {
        initialProgressSeconds = args['progressSeconds'] as int;
      }
      if (story.value == null && args['storyId'] != null) {
        final id = args['storyId'].toString();
        final detail = await _repository.getAudioStoryDetail(id);
        if (detail != null) {
          story.value = detail;
        }
      }
    }

    if (story.value != null && story.value!.episodes.isNotEmpty) {
      currentEpisodeIndex.value = initialEpisodeIndex.clamp(0, story.value!.episodes.length - 1);
      await loadAndPlayEpisode(
        story.value!.episodes[currentEpisodeIndex.value],
        startPositionSeconds: initialProgressSeconds,
      );
    }
  }

  AudioEpisodeModel? get currentEpisode {
    final s = story.value;
    if (s != null && s.episodes.isNotEmpty && currentEpisodeIndex.value < s.episodes.length) {
      return s.episodes[currentEpisodeIndex.value];
    }
    return null;
  }

  String get currentPositionFormatted => _formatDuration(currentPosition.value.toInt());
  String get totalDurationFormatted => _formatDuration(totalDuration.value.toInt());

  double get progress =>
      totalDuration.value > 0 ? (currentPosition.value / totalDuration.value).clamp(0.0, 1.0) : 0.0;

  /// Load and Play episode stream
  Future<void> loadAndPlayEpisode(AudioEpisodeModel episode, {int startPositionSeconds = 0}) async {
    try {
      isLoadingAudio.value = true;
      _saveProgress(); // Save previous episode's progress if any

      // 1. Fetch streaming URL from API (Endpoint 6: GET /api/audio-episodes/<episode_id>/play)
      String? audioStreamUrl = await _repository.playAudioEpisode(episode.id);

      // Fallback to episode model's audioUrl if API returns relative or null
      if (audioStreamUrl == null || audioStreamUrl.isEmpty) {
        audioStreamUrl = episode.audioUrl;
      }

      final resolvedUrl = formatMediaUrl(audioStreamUrl);
      currentStreamingUrl.value = resolvedUrl;

      // 2. Fetch remote progress if startPositionSeconds was not provided (Endpoint 10: GET /api/audio-progress/<episode_id>)
      if (startPositionSeconds <= 0 && episode.progressSeconds > 0) {
        startPositionSeconds = episode.progressSeconds;
      } else if (startPositionSeconds <= 0) {
        final savedProg = await _repository.getEpisodeProgress(episode.id);
        if (savedProg != null && savedProg.progressSeconds > 0 && !savedProg.isCompleted) {
          startPositionSeconds = savedProg.progressSeconds;
        }
      }

      if (resolvedUrl.isNotEmpty) {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(resolvedUrl));

        if (startPositionSeconds > 0) {
          await _audioPlayer.seek(Duration(seconds: startPositionSeconds));
          currentPosition.value = startPositionSeconds.toDouble();
          seekValue.value = startPositionSeconds.toDouble();
        }

        if (episode.durationSeconds > 0) {
          totalDuration.value = episode.durationSeconds.toDouble();
        }
      } else {
        // Fallback simulation timer if no remote audio stream available
        if (episode.durationSeconds > 0) {
          totalDuration.value = episode.durationSeconds.toDouble();
        } else {
          totalDuration.value = 300.0;
        }
      }
    } catch (e) {
      debugPrint("loadAndPlayEpisode error: $e");
    } finally {
      isLoadingAudio.value = false;
    }
  }

  void togglePlayPause() async {
    if (isPlaying.value) {
      await _audioPlayer.pause();
      _saveProgress();
    } else {
      if (currentStreamingUrl.value.isNotEmpty) {
        await _audioPlayer.resume();
      } else if (currentEpisode != null) {
        await loadAndPlayEpisode(currentEpisode!);
      }
    }
  }

  void seekTo(double seconds) {
    currentPosition.value = seconds;
    seekValue.value = seconds;
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
    _saveProgress();
  }

  void skipForward([int seconds = 15]) {
    final max = totalDuration.value;
    final newPos = (currentPosition.value + seconds).clamp(0.0, max > 0 ? max : 9999.0);
    seekTo(newPos);
  }

  void skipBackward([int seconds = 15]) {
    final newPos = (currentPosition.value - seconds).clamp(0.0, totalDuration.value);
    seekTo(newPos);
  }

  void playNext() {
    final s = story.value;
    if (s != null && currentEpisodeIndex.value < s.episodes.length - 1) {
      currentEpisodeIndex.value++;
      loadAndPlayEpisode(s.episodes[currentEpisodeIndex.value]);
    }
  }

  void playPrevious() {
    final s = story.value;
    if (s != null && currentEpisodeIndex.value > 0) {
      currentEpisodeIndex.value--;
      loadAndPlayEpisode(s.episodes[currentEpisodeIndex.value]);
    }
  }

  void selectEpisode(int index) {
    final s = story.value;
    if (s != null && index >= 0 && index < s.episodes.length) {
      currentEpisodeIndex.value = index;
      loadAndPlayEpisode(s.episodes[index]);
    }
  }

  /// 7. Save Progress to Backend (POST /api/audio-progress)
  Future<void> _saveProgress() async {
    final ep = currentEpisode;
    if (ep == null || ep.id.isEmpty) return;

    final prog = currentPosition.value.toInt();
    final dur = totalDuration.value.toInt();
    if (prog <= 0) return;

    await _repository.saveAudioProgress(
      episodeId: ep.id,
      progressSeconds: prog,
      durationSeconds: dur > 0 ? dur : ep.durationSeconds,
    );
  }

  /// 9. Handle episode completion (POST /api/audio-progress/{episode_id}/complete)
  Future<void> _onEpisodeCompleted() async {
    final ep = currentEpisode;
    if (ep != null && ep.id.isNotEmpty) {
      await _repository.markEpisodeCompleted(ep.id);
    }

    // Auto-advance to next episode
    final s = story.value;
    if (s != null && currentEpisodeIndex.value < s.episodes.length - 1) {
      playNext();
    }
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
