import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:video_player/video_player.dart';

const List<Map<String, dynamic>> _reelFeed = [
  {
    'title': 'My Racer Stepbrother',
    'subtitle': 'Episode 01',
    'story': 'A world where time slows down',
    'username': '@ai.creations',
    'avatarUrl': 'https://picsum.photos/seed/avatar1/100/100',
    'likes': 12800,
    'comments': 11500,
    'shares': 50000,
    'videoUrl':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'imageUrl': 'https://picsum.photos/seed/drama1/400/600',
  },
  {
    'title': 'Forbidden Love',
    'subtitle': 'Episode 01',
    'story': 'When love and revenge collide, destiny writes a forbidden story',
    'username': '@storyverse',
    'avatarUrl': 'https://picsum.photos/seed/avatar2/100/100',
    'likes': 9400,
    'comments': 8100,
    'shares': 31000,
    'videoUrl':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'imageUrl': 'https://picsum.photos/seed/drama5/400/600',
  },
  {
    'title': 'Connect',
    'subtitle': 'Episode 01',
    'story':
        'Two strangers meet by chance, but destiny leads them into a forbidden romance',
    'username': '@dramahub',
    'avatarUrl': 'https://picsum.photos/seed/avatar3/100/100',
    'likes': 7800,
    'comments': 6200,
    'shares': 22000,
    'videoUrl':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'imageUrl': 'https://picsum.photos/seed/drama4/400/600',
  },
  {
    'title': 'The True Heiress',
    'subtitle': 'Episode 01',
    'story':
        'She was stripped of everything. Now she returns to reclaim what was always hers',
    'username': '@heiresstv',
    'avatarUrl': 'https://picsum.photos/seed/avatar4/100/100',
    'likes': 11200,
    'comments': 10300,
    'shares': 44000,
    'videoUrl':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'imageUrl': 'https://picsum.photos/seed/drama3/400/600',
  },
];

class ReelsTab extends StatefulWidget {
  const ReelsTab({super.key});

  @override
  State<ReelsTab> createState() => _ReelsTabState();
}

class _ReelsTabState extends State<ReelsTab> {
  int _currentIndex = 0;
  int _selectedFeedTab = 1; // 0 = For You, 1 = Trending

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _reelFeed.length,
          onPageChanged: (i) => setState(() => _currentIndex = i),
          itemBuilder: (_, index) => _ReelItem(
            data: _reelFeed[index],
            isActive: _currentIndex == index,
          ),
        ),

        // ── Top pills: For You / Trending (floating, no wrapper track) ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: _FeedToggle(
                  selectedIndex: _selectedFeedTab,
                  onChanged: (i) => setState(() => _selectedFeedTab = i),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// For You / Trending floating pills
// ─────────────────────────────────────────────────────────────────────────────
class _FeedToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _FeedToggle({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _pill(label: 'For You', index: 0, bgColor: AppColors.white),
        const SizedBox(width: 8),
        _pill(label: 'Trending', index: 1, bgColor: AppColors.accentColor),
      ],
    );
  }

  Widget _pill({
    required String label,
    required int index,
    required Color bgColor,
  }) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onChanged(index),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isSelected ? 1 : 0.75,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: text13(fontWeight: FontWeight.w700, color: AppColors.black),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual Reel
// ─────────────────────────────────────────────────────────────────────────────
class _ReelItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isActive;

  const _ReelItem({required this.data, required this.isActive});

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  late VideoPlayerController _vpc;
  bool _initialized = false;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _vpc =
        VideoPlayerController.networkUrl(
            Uri.parse(widget.data['videoUrl'] as String),
          )
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
  void didUpdateWidget(covariant _ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_initialized) {
      widget.isActive ? _vpc.play() : _vpc.pause();
    }
  }

  @override
  void dispose() {
    _vpc.dispose();
    super.dispose();
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video / fallback
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
                  widget.data['imageUrl'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: AppColors.cardColor),
                ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.0, 0.25, 0.55, 1.0],
              ),
            ),
          ),

          // Tap to toggle play
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

          // Right actions
          Positioned(
            right: 14,
            bottom: 130,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _IconAction(
                  label: _fmt(widget.data['likes'] as int),
                  onTap: () => setState(() => _liked = !_liked),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: AppColors.accentColor,
                    size: 30,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _IconAction(
                  // Dot-style comment bubble to match reference (dark circle, three dots)
                  label: _fmt(widget.data['comments'] as int),
                  onTap: () {},
                  // Dot-style comment bubble to match reference (dark circle, three dots)
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _IconAction(
                  flip: true,
                  label: _fmt(widget.data['shares'] as int),
                  onTap: () {},
                  child: const Icon(
                    Icons.reply_rounded,
                    color: Colors.white,
                    size: 28,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom info
          Positioned(
            left: 16,
            right: 80,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar + username row
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.data['avatarUrl'] as String,
                        width: 26,
                        height: 26,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 26,
                          height: 26,
                          color: AppColors.cardColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.data['username'] as String,
                      style: text13(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        widget.data['story'] as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text12(
                          color: AppColors.white,
                        ).copyWith(height: 1.35),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('✨', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          // Progress bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _initialized
                ? ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _vpc,
                    builder: (_, val, _) {
                      final p = val.duration.inMilliseconds > 0
                          ? val.position.inMilliseconds /
                                val.duration.inMilliseconds
                          : 0.0;
                      return LinearProgressIndicator(
                        value: p.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.accentColor,
                        ),
                        minHeight: 3,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback onTap;
  final bool flip;

  const _IconAction({
    required this.child,
    required this.label,
    required this.onTap,
    this.flip = false,
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
            transform: flip
                ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
                : Matrix4.identity(),
            child: child,
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
