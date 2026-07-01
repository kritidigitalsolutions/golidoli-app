import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_player_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:video_player/video_player.dart';

// Free public domain short video clips
const List<String> _freeVideoUrls = [
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
  'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
];

class MicroDramaPlayerScreen extends StatelessWidget {
  const MicroDramaPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final controller = Get.put(MicroDramaPlayerController());

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.feed.length,
          onPageChanged: controller.onPageChanged,
          controller: PageController(
            initialPage: controller.currentIndex.value,
          ),
          itemBuilder: (_, index) {
            final drama = controller.feed[index];
            return _DramaReelItem(
              drama: drama,
              playerController: controller,
              isActive: controller.currentIndex.value == index,
              videoUrl: _freeVideoUrls[index % _freeVideoUrls.length],
            );
          },
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Reel Item with video_player
// ─────────────────────────────────────────────────────────────────────────────
class _DramaReelItem extends StatefulWidget {
  final dynamic drama;
  final MicroDramaPlayerController playerController;
  final bool isActive;
  final String videoUrl;

  const _DramaReelItem({
    required this.drama,
    required this.playerController,
    required this.isActive,
    required this.videoUrl,
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
    _vpc = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
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
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Video or fallback image ───────────────────────────────────────
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
                  widget.drama.imageUrl,
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

          // ── Dark vignette gradient ────────────────────────────────────────
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

          // ── Tap to play/pause ─────────────────────────────────────────────
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
          ),

          // ── Top bar ───────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.edgeToEdge,
                      );
                      Get.back();
                    },
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

          // ── Right side actions ────────────────────────────────────────────
          Positioned(
            right: 12,
            bottom: 140,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionButton(
                    icon: widget.playerController.isLiked.value
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: widget.playerController.isLiked.value
                        ? AppColors.accentColor
                        : AppColors.white,
                    label: widget.playerController.formatCount(
                      widget.drama.likes,
                    ),
                    onTap: widget.playerController.toggleLike,
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: AppColors.white,
                    label: widget.playerController.formatCount(
                      widget.drama.comments,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  _ActionButton(
                    icon: Icons.reply_rounded,
                    iconColor: AppColors.white,
                    label: widget.playerController.formatCount(
                      widget.drama.shares,
                    ),
                    onTap: () {},
                    flipHorizontal: true,
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom info ───────────────────────────────────────────────────
          Positioned(
            left: 16,
            right: 70,
            bottom: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.drama.title,
                  style: text18(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.drama.subtitle,
                  style: text13(color: AppColors.secondaryTextColor),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.drama.story,
                  style: text12(color: AppColors.secondaryTextColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: widget.playerController.onShowMore,
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

          // ── Video progress bar ────────────────────────────────────────────
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
// Action button widget
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
