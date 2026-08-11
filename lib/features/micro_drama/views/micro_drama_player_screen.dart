import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:video_player/video_player.dart';

// ✅ Use the SAME model as the BLoC – from episode_response.dart
import '../../web_series/model/episode_response.dart';

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
  State<MicroDramaPlayerScreen> createState() =>
      _MicroDramaPlayerScreenState();
}

class _MicroDramaPlayerScreenState extends State<MicroDramaPlayerScreen> {
  late int currentIndex = widget.initialIndex;
  final Set<int> likedIndices = {};
  late final PageController _pageController = PageController(
    initialPage: widget.initialIndex,
  );
  late final MicroDramaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MicroDramaController>();
    _controller.fetchEpisodeDetail(widget.dramaId);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => currentIndex = index);
  }

  void _toggleLike(int index) {
    setState(() {
      if (likedIndices.contains(index)) {
        likedIndices.remove(index);
      } else {
        likedIndices.add(index);
      }
    });
  }

  void _onShowMore(Episode episode) {
    // TODO: show a details bottom sheet
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

        if (widget.initialIndex >= episodes.length) {
          currentIndex = episodes.length - 1;
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: episodes.length,
          onPageChanged: _onPageChanged,
          controller: _pageController,
          itemBuilder: (_, index) {
            final episode = episodes[index];
            return _DramaReelItem(
              episode: episode,
              isActive: currentIndex == index,
              isLiked: likedIndices.contains(index),
              onToggleLike: () => _toggleLike(index),
              onShowMore: () => _onShowMore(episode),
              onBack: _onBack,
            );
          },
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reel Item – uses Episode (not EpisodeModel)
// ─────────────────────────────────────────────────────────────────────────────
class _DramaReelItem extends StatefulWidget {
  final Episode episode;
  final bool isActive;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onShowMore;
  final VoidCallback onBack;

  const _DramaReelItem({
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
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final videoUrl = '${AppUrl.baseUrl}${widget.episode.videoUrl}';
    _vpc = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          if (widget.isActive) {
            _vpc.setLooping(true);
            _vpc.play();
          }
        }
      });
  }

  @override
  void didUpdateWidget(covariant _DramaReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && _initialized) {
      _vpc.play();
    } else if (!widget.isActive && _initialized) {
      _vpc.pause();
    }
  }

  @override
  void dispose() {
    _vpc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Video or thumbnail ──────────────────────────────────────────
          _initialized
              ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _vpc.value.size.width,
              height: _vpc.value.size.height,
              child: VideoPlayer(_vpc),
            ),
          )
              : Image.network(
            '${AppUrl.baseUrl}${episode.thumbnail}',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.cardColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accentColor,
                ),
              ),
            ),
          ),

         /* // ── Lock overlay ────────────────────────────────────────────────
          if (episode)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),*/

          // ── Vignette ─────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          /*// ── Tap to play/pause (only if not locked) ────────────────────
          if (!episode.isLocked)
            GestureDetector(
              onTap: () {
                if (_initialized) {
                  setState(() {
                    _vpc.value.isPlaying ? _vpc.pause() : _vpc.play();
                  });
                }
              },
              behavior: HitTestBehavior.translucent,
              child: const SizedBox.expand(),
            ),*/

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
          Positioned(
            right: 12,
            bottom: 140,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: widget.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: widget.isLiked
                      ? AppColors.accentColor
                      : AppColors.white,
                  label: formatCount(1),
                  onTap: widget.onToggleLike,
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: AppColors.white,
                  label: formatCount(1),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.reply_rounded,
                  iconColor: AppColors.white,
                  label: 'Share',
                  onTap: () {},
                  flipHorizontal: true,
                ),
              ],
            ),
          ),

          // ── Bottom info ─────────────────────────────────────────────────
          Positioned(
            left: 16,
            right: 70,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  episode.title,
                  style: text18(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Episode ${episode.episodeNumber}',
                  style: text13(color: AppColors.secondaryTextColor),
                ),
                const SizedBox(height: 8),
                Text(
                  episode.description,
                  style: text12(color: AppColors.secondaryTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: widget.onShowMore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Show More',
                      style: text12(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Progress bar ────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _initialized
                ? ValueListenableBuilder<VideoPlayerValue>(
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
            )
                : LinearProgressIndicator(
              value: 0,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(
                AppColors.accentColor,
              ),
              minHeight: 3,
            ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: flipHorizontal
                ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
                : Matrix4.identity(),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: text11(color: AppColors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}