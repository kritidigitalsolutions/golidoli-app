import 'dart:async';
import 'package:get/get.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';

class AudioPlayerController extends GetxController {
  late AudioStoryModel story;

  final RxInt currentEpisodeIndex = 0.obs;
  final RxBool isPlaying = true.obs;
  final RxDouble currentPosition = 0.0.obs; // in seconds
  final RxDouble totalDuration = 745.0.obs; // in seconds (12:25)
  final RxDouble seekValue = 0.0.obs;

  Timer? _progressTimer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is AudioStoryModel) {
      story = Get.arguments as AudioStoryModel;
    } else {
      story = _fallbackStory();
    }
    _startTimer();
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    super.onClose();
  }

  AudioEpisodeModel get currentEpisode =>
      story.episodes[currentEpisodeIndex.value];

  String get currentPositionFormatted => _formatDuration(currentPosition.value.toInt());
  String get totalDurationFormatted => _formatDuration(totalDuration.value.toInt());

  double get progress =>
      totalDuration.value > 0 ? currentPosition.value / totalDuration.value : 0.0;

  void _startTimer() {
    _progressTimer?.cancel();
    if (isPlaying.value) {
      _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (isPlaying.value) {
          if (currentPosition.value < totalDuration.value) {
            currentPosition.value += 1;
            seekValue.value = currentPosition.value;
          } else {
            playNext();
          }
        }
      });
    }
  }

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      _startTimer();
    } else {
      _progressTimer?.cancel();
    }
  }

  void seekTo(double value) {
    currentPosition.value = value;
    seekValue.value = value;
  }

  void skipForward() {
    final newPos = (currentPosition.value + 15).clamp(0.0, totalDuration.value);
    currentPosition.value = newPos;
    seekValue.value = newPos;
  }

  void skipBackward() {
    final newPos = (currentPosition.value - 15).clamp(0.0, totalDuration.value);
    currentPosition.value = newPos;
    seekValue.value = newPos;
  }

  void playNext() {
    if (currentEpisodeIndex.value < story.episodes.length - 1) {
      currentEpisodeIndex.value++;
      currentPosition.value = 0;
      seekValue.value = 0;
      isPlaying.value = true;
      _startTimer();
    }
  }

  void playPrevious() {
    if (currentEpisodeIndex.value > 0) {
      currentEpisodeIndex.value--;
      currentPosition.value = 0;
      seekValue.value = 0;
      isPlaying.value = true;
      _startTimer();
    }
  }

  void selectEpisode(int index) {
    currentEpisodeIndex.value = index;
    currentPosition.value = 0;
    seekValue.value = 0;
    isPlaying.value = true;
    _startTimer();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

AudioStoryModel _fallbackStory() {
  final episodes = List.generate(
    6,
    (i) => AudioEpisodeModel(
      id: 'ep_${i + 1}',
      title: 'Karmayoddha – Ep ${i + 1}',
      storyTitle: 'Karmayoddha',
      episodeNumber: i + 1,
      fileSize: '18 MB',
      imageUrl: 'https://picsum.photos/seed/karma${i + 1}/200/300',
      duration: const Duration(minutes: 12, seconds: 30),
    ),
  );
  return AudioStoryModel(
    id: 'story_1',
    title: 'KARMAYODDHA',
    subtitle: 'The Rise of a Warrior',
    imageUrl: 'https://picsum.photos/seed/warrior1/700/400',
    genre: 'Action',
    rating: 4.8,
    totalEpisodes: 45,
    duration: '12h 30m',
    totalPlays: 12500,
    description: 'The untold story of a warrior who fought against all odds.',
    episodes: episodes,
  );
}
