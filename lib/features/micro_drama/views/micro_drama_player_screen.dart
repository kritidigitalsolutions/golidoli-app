import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_controller.dart';
import 'package:golidoli_app/features/micro_drama/models/episode_detail_response.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:video_player/video_player.dart';

String formatCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '$n';
}

class MicroDramaPlayerScreen extends StatefulWidget {
  final String dramaId;
  final int initialIndex;

  const MicroDramaPlayerScreen({
    super.key,
    required this.dramaId,
    this.initialIndex = 0,
  });

  @override
  State<MicroDramaPlayerScreen> createState() => _MicroDramaPlayerScreenState();
}

class _MicroDramaPlayerScreenState extends State<MicroDramaPlayerScreen> {
  late final PageController _pageController;
  late final MicroDramaController _controller;
  final RxInt currentIndex = 0.obs;
  final RxSet<int> likedIndices = <int>{}.obs;

  // Stable per-index keys so we can explicitly command play/pause on the
  // exact item, regardless of build/scroll timing.
  final Map<int, GlobalKey<_DramaReelItemState>> _itemKeys = {};

  GlobalKey<_DramaReelItemState> _keyFor(int index) {
    return _itemKeys.putIfAbsent(index, () => GlobalKey<_DramaReelItemState>());
  }

  @override
  void initState() {
    super.initState();
    currentIndex.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _controller = Get.isRegistered<MicroDramaController>()
        ? Get.find<MicroDramaController>()
        : Get.put(MicroDramaController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.episodeDetail.value == null ||
          _controller.episodeDetail.value?.episodes.isEmpty == true) {
        _controller.fetchEpisodeDetail(widget.dramaId);
      }
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onPageChanged(int index) {
    currentIndex.value = index;
    // The new current page is guaranteed to be mounted by now — command
    // play explicitly instead of relying on didUpdateWidget/init race.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyFor(index).currentState?.ensurePlaying();
    });
  }

  void _toggleLike(int index) {
    if (likedIndices.contains(index)) {
      likedIndices.remove(index);
    } else {
      likedIndices.add(index);
    }
  }

  void _onBack() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).maybePop();
  }

  void _onEpisodeComplete(int index, int totalEpisodes) {
    if (index + 1 < totalEpisodes) {
      final nextIndex = index + 1;
      _pageController
          .animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
          )
          .then((_) {
            // Safety net in case onPageChanged's post-frame call raced with
            // the video still initializing.
            _keyFor(nextIndex).currentState?.ensurePlaying();
          });
    } else {
      // Last episode finished — auto back
      _onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
        if (_controller.episodeDetailStatus.value == Status.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentColor),
          );
        }

        if (_controller.episodeDetailStatus.value == Status.error ||
            _controller.episodeDetail.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load episodes',
                  style: text15(color: AppColors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller.fetchEpisodeDetail(widget.dramaId);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final episodes = _controller.episodeDetail.value!.episodes;
        if (episodes.isEmpty) {
          return const Center(
            child: Text(
              'No episodes available',
              style: TextStyle(color: AppColors.white),
            ),
          );
        }

        return SafeArea(
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: episodes.length,
            onPageChanged: _onPageChanged,
            controller: _pageController,
            itemBuilder: (_, index) {
              final episode = episodes[index];
              return _DramaReelItem(
                key: _keyFor(index),
                episode: episode,
                episodeIndex: index,
                totalEpisodes: episodes.length,
                isActive: currentIndex.value == index,
                isLiked: likedIndices.contains(index),
                onToggleLike: () => _toggleLike(index),
                onBack: _onBack,
                onEpisodeComplete: () =>
                    _onEpisodeComplete(index, episodes.length),
              );
            },
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reel Item
// ─────────────────────────────────────────────────────────────────────────────
class _DramaReelItem extends StatefulWidget {
  final MicroDramaEpisode episode;
  final int episodeIndex;
  final int totalEpisodes;
  final bool isActive;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onBack;
  final VoidCallback onEpisodeComplete;

  const _DramaReelItem({
    super.key,
    required this.episode,
    required this.episodeIndex,
    required this.totalEpisodes,
    required this.isActive,
    required this.isLiked,
    required this.onToggleLike,
    required this.onBack,
    required this.onEpisodeComplete,
  });

  @override
  State<_DramaReelItem> createState() => _DramaReelItemState();
}

class _DramaReelItemState extends State<_DramaReelItem> {
  late VideoPlayerController _vpc;
  final RxBool isInitialized = false.obs;
  final RxBool showPlayPauseIcon = false.obs;
  final RxBool showControls = true.obs;
  final RxBool isMuted = false.obs;
  final RxBool isInWatchlist = false.obs;
  final RxBool isDownloaded = false.obs;

  Timer? _hideControlsTimer;
  bool _hasCompleted = false;
  bool _autoPlayPending = false;

  @override
  void initState() {
    super.initState();
    final videoUrl = formatMediaUrl(widget.episode.videoUrl);
    _vpc =
        VideoPlayerController.networkUrl(
            Uri.parse(videoUrl),
            httpHeaders: {
              'User-Agent':
                  'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
              'Accept': '*/*',
            },
          )
          ..initialize()
              .then((_) {
                if (!mounted) return;
                isInitialized.value = true;
                if (widget.isActive || _autoPlayPending) {
                  _autoPlayPending = false;
                  _vpc.setLooping(false);
                  _vpc.play();
                  _startHideControlsTimer();
                }
                _vpc.addListener(_onVideoTick);
              })
              .catchError((err) {
                debugPrint("Error initializing video player: $err");
              });
  }

  /// Explicitly commanded by the parent when this page becomes the current
  /// page (swipe or auto-advance). Deterministic — no reliance on rebuild
  /// timing vs. video-initialize timing.
  void ensurePlaying() {
    if (!mounted) return;
    _hasCompleted = false;
    if (isInitialized.value) {
      _vpc.setLooping(false);
      _vpc.play();
      _startHideControlsTimer();
    } else {
      _autoPlayPending = true;
    }
  }

  void _onVideoTick() {
    if (!_vpc.value.isInitialized || _hasCompleted) return;
    final duration = _vpc.value.duration;
    final position = _vpc.value.position;
    if (duration.inMilliseconds > 0 &&
        position.inMilliseconds >= duration.inMilliseconds - 200) {
      _hasCompleted = true;
      widget.onEpisodeComplete();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    showControls.value = true;
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (isInitialized.value && _vpc.value.isPlaying) {
        showControls.value = false;
      }
    });
  }

  @override
  void didUpdateWidget(covariant _DramaReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isActive && isInitialized.value) {
      _vpc.pause();
      _hideControlsTimer?.cancel();
      showControls.value = true;
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _vpc.removeListener(_onVideoTick);
    _vpc.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!isInitialized.value) return;
    if (_vpc.value.isPlaying) {
      _vpc.pause();
      _hideControlsTimer?.cancel();
      showControls.value = true;
    } else {
      _vpc.play();
      _startHideControlsTimer();
    }
    showPlayPauseIcon.value = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      showPlayPauseIcon.value = false;
    });
  }

  void _toggleMute() {
    isMuted.value = !isMuted.value;
    _vpc.setVolume(isMuted.value ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;
    final size = MediaQuery.of(context).size;
    final thumbnailUrl = formatMediaUrl(episode.thumbnail);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Video or thumbnail ──────────────────────────────────────────
          Obx(() {
            if (isInitialized.value) {
              return Center(
                child: AspectRatio(
                  aspectRatio: _vpc.value.aspectRatio,
                  child: VideoPlayer(_vpc),
                ),
              );
            }
            if (thumbnailUrl.isNotEmpty) {
              return Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.cardColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: AppColors.black,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.accentColor),
              ),
            );
          }),

          // ── Tap to Play/Pause ────────────────────────────────────────────
          GestureDetector(
            onTap: _togglePlayPause,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),

          // ── Play/Pause Icon overlay (animated) ────────────────────────────
          Obx(() {
            if (!isInitialized.value) return const SizedBox.shrink();
            return IgnorePointer(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) => ScaleTransition(
                    scale: anim,
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: showPlayPauseIcon.value
                      ? Container(
                          key: ValueKey(_vpc.value.isPlaying),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _vpc.value.isPlaying
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ),
            );
          }),

          // ── Right side actions (auto-hides) ──────────────────────────────
          Positioned(
            right: 12,
            bottom: 50,
            child: Obx(
              () => AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showControls.value ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !showControls.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => _ActionButton(
                          icon: isInWatchlist.value
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          iconColor: isInWatchlist.value
                              ? AppColors.accentColor
                              : AppColors.white,
                          label: 'Like',
                          onTap: () =>
                              isInWatchlist.value = !isInWatchlist.value,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => _ActionButton(
                          icon: isDownloaded.value
                              ? Icons.download_done_rounded
                              : Icons.download_rounded,
                          iconColor: isDownloaded.value
                              ? AppColors.accentColor
                              : AppColors.white,
                          label: 'Download',
                          onTap: () => isDownloaded.value = !isDownloaded.value,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => _ActionButton(
                          icon: isMuted.value
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          iconColor: AppColors.white,
                          label: isMuted.value ? 'Muted' : 'Sound',
                          onTap: _toggleMute,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom info: episode number / total (always visible) ─────────
          Positioned(
            left: 16,
            right: 70,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ep ${episode.episodeNumber} / ${widget.totalEpisodes}',
                  style: text13(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),

          // ── Progress bar (always visible) ─────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(() {
              if (isInitialized.value) {
                return ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _vpc,
                  builder: (_, val, _) {
                    final progress = val.duration.inMilliseconds > 0
                        ? val.position.inMilliseconds /
                              val.duration.inMilliseconds
                        : 0.0;
                    return LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.accentColor,
                      ),
                      minHeight: 3,
                    );
                  },
                );
              }
              return LinearProgressIndicator(
                value: 0,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(AppColors.accentColor),
                minHeight: 3,
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action button
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool flipHorizontal;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.flipHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Transform.flip(
            flipX: flipHorizontal,
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 4),
          Text(label, style: text10(color: AppColors.white)),
        ],
      ),
    );
  }
}
