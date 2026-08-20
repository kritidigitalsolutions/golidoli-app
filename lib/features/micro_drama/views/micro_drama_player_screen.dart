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
  }

  void _toggleLike(int index) {
    if (likedIndices.contains(index)) {
      likedIndices.remove(index);
    } else {
      likedIndices.add(index);
    }
  }

  void _onShowMore(MicroDramaEpisode episode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EP ${episode.episodeNumber}: ${episode.title}',
                style: text18(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (episode.duration.isNotEmpty)
                Text(
                  'Duration: ${episode.duration}',
                  style: text12(color: AppColors.hintTextColor),
                ),
              const SizedBox(height: 12),
              Text(
                episode.description.isNotEmpty
                    ? episode.description
                    : 'No description available.',
                style: text14(color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _onBack() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.of(context).maybePop();
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
                episode: episode,
                isActive: currentIndex.value == index,
                isLiked: likedIndices.contains(index),
                onToggleLike: () => _toggleLike(index),
                onShowMore: () => _onShowMore(episode),
                onBack: _onBack,
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
  final bool isActive;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onShowMore;
  final VoidCallback onBack;

  const _DramaReelItem({
    super.key,
    required this.episode,
    required this.isActive,
    required this.isLiked,
    required this.onToggleLike,
    required this.onShowMore,
    required this.onBack,
  });

  @override
  State<_DramaReelItem> createState() => _DramaReelItemState();
}

class _DramaReelItemState extends State<_DramaReelItem> {
  late VideoPlayerController _vpc;
  final RxBool isInitialized = false.obs;
  final RxBool showPlayPauseIcon = false.obs;

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
                isInitialized.value = true;
                if (widget.isActive) {
                  _vpc.setLooping(true);
                  _vpc.play();
                }
              })
              .catchError((err) {
                debugPrint("Error initializing video player: $err");
              });
  }

  @override
  void didUpdateWidget(covariant _DramaReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && isInitialized.value) {
      _vpc.play();
    } else if (!widget.isActive && isInitialized.value) {
      _vpc.pause();
    }
  }

  @override
  void dispose() {
    _vpc.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!isInitialized.value) return;
    if (_vpc.value.isPlaying) {
      _vpc.pause();
    } else {
      _vpc.play();
    }
    showPlayPauseIcon.value = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      showPlayPauseIcon.value = false;
    });
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

          // ── Vignette gradient ─────────────────────────────────────────────
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.black.withOpacity(0.4),
          //         Colors.transparent,
          //         Colors.transparent,
          //         Colors.black.withOpacity(0.8),
          //       ],
          //       stops: const [0.0, 0.25, 0.6, 1.0],
          //     ),
          //   ),
          // ),

          // ── Tap to Play/Pause ────────────────────────────────────────────
          GestureDetector(
            onTap: _togglePlayPause,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),

          // ── Play/Pause Icon overlay ──────────────────────────────────────
          Obx(() {
            if (!showPlayPauseIcon.value || !isInitialized.value) {
              return const SizedBox.shrink();
            }
            return Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showPlayPauseIcon.value ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _vpc.value.isPlaying
                        ? Icons.play_arrow_rounded
                        : Icons.pause_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            );
          }),

          // ── Top bar ─────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  Text('GoliDoli', style: text16(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 36),
                ],
              ),
            ),
          ),

          // ── Right side actions ──────────────────────────────────────────
          // Positioned(
          //   right: 12,
          //   bottom: 140,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       _ActionButton(
          //         icon: widget.isLiked
          //             ? Icons.favorite_rounded
          //             : Icons.favorite_border_rounded,
          //         iconColor: widget.isLiked
          //             ? AppColors.accentColor
          //             : AppColors.white,
          //         label: formatCount(episode.likes > 0 ? episode.likes : 1),
          //         onTap: widget.onToggleLike,
          //       ),
          //       const SizedBox(height: 20),
          //       _ActionButton(
          //         icon: Icons.remove_red_eye_outlined,
          //         iconColor: AppColors.white,
          //         label: formatCount(episode.views > 0 ? episode.views : 1),
          //         onTap: () {},
          //       ),
          //       const SizedBox(height: 20),
          //       _ActionButton(
          //         icon: Icons.reply_rounded,
          //         iconColor: AppColors.white,
          //         label: 'Share',
          //         onTap: () {},
          //         flipHorizontal: true,
          //       ),
          //     ],
          //   ),
          // ),

          // ── Bottom info ─────────────────────────────────────────────────
          Positioned(
            left: 16,
            right: 70,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(episode.title, style: text18(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Episode ${episode.episodeNumber}',
                  style: text13(color: AppColors.secondaryTextColor),
                ),
                // if (episode.description.isNotEmpty) ...[
                //   const SizedBox(height: 8),
                //   Text(
                //     episode.description,
                //     style: text12(color: AppColors.secondaryTextColor),
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ],
                // const SizedBox(height: 12),
                // GestureDetector(
                //   onTap: widget.onShowMore,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 8,
                //     ),
                //     decoration: BoxDecoration(
                //       color: AppColors.primaryColor,
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Text(
                //       'Show More',
                //       style: text12(
                //         color: AppColors.black,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // ── Progress bar ────────────────────────────────────────────────
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

// // ─────────────────────────────────────────────────────────────────────────────
// // Action button
// // ─────────────────────────────────────────────────────────────────────────────
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String label;
//   final VoidCallback onTap;
//   final bool flipHorizontal;

//   const _ActionButton({
//     required this.icon,
//     required this.iconColor,
//     required this.label,
//     required this.onTap,
//     this.flipHorizontal = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Transform.flip(
//             flipX: flipHorizontal,
//             child: Icon(icon, color: iconColor, size: 28),
//           ),
//           const SizedBox(height: 4),
//           Text(label, style: text10(color: AppColors.white)),
//         ],
//       ),
//     );
//   }
// }
