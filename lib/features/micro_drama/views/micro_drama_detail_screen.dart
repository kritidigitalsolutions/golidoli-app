import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/bloc/micro_drama_bloc.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_player_screen.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MicroDramaDetailScreen extends StatefulWidget {
  final String id;

  const MicroDramaDetailScreen({super.key, required this.id});

  @override
  State<MicroDramaDetailScreen> createState() =>
      _MicroDramaDetailScreenState();
}

class _MicroDramaDetailScreenState extends State<MicroDramaDetailScreen> {
  bool isInWatchlist = false;
  int selectedEpisode = 0;

  static const int _freeEpisodeCount = 3;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<MicroDramaBloc>();
    bloc.add(MicroDramaEvent.detailMicroDrama(id: widget.id));
    bloc.add(const MicroDramaEvent.allMicroDrama());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<MicroDramaBloc, MicroDramaState>(
        builder: (context, state) {
          // Loading state
          if (state.detailDramaStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (state.detailDramaStatus == Status.error ||
              state.dramaDetail == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load drama details',
                    style: text15(color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MicroDramaBloc>().add(
                          MicroDramaEvent.detailMicroDrama(id: widget.id));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final drama = state.dramaDetail!.microdrama;

          // ✅ Extract the list from the wrapper object.
          // If the field name is different (e.g., 'data'), change it accordingly.
          final allDramas = state.allMicroDrama?.microdramas ?? [];
          final similarDramas = allDramas
              .where(
                (d) =>
            d.id != drama.id &&
                d.genre.any((g) => drama.genre.contains(g)),
          )
              .toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(drama)),
              SliverToBoxAdapter(child: _buildRatingAndTags(drama)),
              SliverToBoxAdapter(child: _buildStory(drama)),
              SliverToBoxAdapter(child: _buildActions(drama)),
              SliverToBoxAdapter(child: _buildEpisodes(drama)),
              if (similarDramas.isNotEmpty)
                SliverToBoxAdapter(
                    child: _buildSimilarDramas(similarDramas.cast<Microdrama>(), drama.id)),
              SliverToBoxAdapter(child: _buildExploreMore()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        },
      ),
    );
  }

  // ── Hero cover ─────────────────────────────────────────────────────────────
  Widget _buildHero(Microdrama drama) {

    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: Image.network(
            "${AppUrl.baseUrl}${drama.banner}",
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 280,
              color: AppColors.cardColor,
              child: Center(
                child: Icon(
                  Icons.movie_outlined,
                  color: AppColors.hintTextColor,
                  size: 60,
                ),
              ),
            ),
          ),
        ),
        // Bottom gradient
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.backgroundColor],
            ),
          ),
        ),
        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconBtn(
                    Icons.arrow_back_ios_new_rounded,
                        () => Navigator.of(context).maybePop(),
                  ),
                  // AI label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.overlayColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.borderColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.primaryColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Ai',
                          style: text11(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Title at bottom of hero
        Positioned(
          bottom: 14,
          left: 16,
          right: 16,
          child: Text(
            drama.title,
            style: text22(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ── Rating & tags ──────────────────────────────────────────────────────────
  Widget _buildRatingAndTags(Microdrama drama) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Rating star
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: AppColors.ratingColor, size: 16),
              const SizedBox(width: 3),
              Text(
                drama.rating.toStringAsFixed(1),
                style: text12(
                  color: AppColors.ratingColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '(${_formatNum(drama.totalViews)})',
                style: text11(color: AppColors.hintTextColor),
              ),
            ],
          ),
          // Tags from genre list
          ...drama.genre.map((genre) => _buildTag(genre.toString())),
          // Additional tags: total episodes, language, etc.
          _buildTag('${drama.totalEpisodes} Episodes'),
          _buildTag(drama.language),
          if (drama.isPremium) _buildTag('Premium'),
          if (drama.isComingSoon) _buildTag('Coming Soon'),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Text(label, style: text11(color: AppColors.secondaryTextColor)),
    );
  }

  // ── Story ──────────────────────────────────────────────────────────────────
  Widget _buildStory(Microdrama drama) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Story', style: text15(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            drama.description,
            style: text13(color: AppColors.secondaryTextColor),
          ),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  Widget _buildActions(Microdrama drama) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          // Start Watching
          Expanded(
            child: GestureDetector(
              onTap: _onStartWatching,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Start Watching',
                      style: text13(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Watchlist
          Expanded(
            child: GestureDetector(
              onTap: _toggleWatchlist,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderColor.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isInWatchlist
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_add_outlined,
                      color: isInWatchlist
                          ? AppColors.primaryColor
                          : AppColors.secondaryTextColor,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isInWatchlist ? 'Saved' : '+ Watchlist',
                      style: text13(
                        color: isInWatchlist
                            ? AppColors.primaryColor
                            : AppColors.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Episodes grid ──────────────────────────────────────────────────────────
  Widget _buildEpisodes(Microdrama drama) {
    final totalEpisodes = drama.totalEpisodes;
    final episodes = List.generate(
      totalEpisodes,
          (i) => {
        'episodeNumber': i + 1,
        'isLocked': i >= _freeEpisodeCount,
      },
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Episodes', style: text15(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(episodes.length, (i) {
              final ep = episodes[i];
              final isLocked = ep['isLocked'] as bool;
              final isSelected = selectedEpisode == i;
              return GestureDetector(
                onTap: () => _onEpisodeTap(i, isLocked),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentColor
                        : isLocked
                        ? AppColors.cardColor
                        : AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentColor
                          : AppColors.borderColor.withOpacity(0.4),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'E${ep['episodeNumber']}',
                        style: text12(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.white
                              : isLocked
                              ? AppColors.disabledColor
                              : AppColors.textColor,
                        ),
                      ),
                      if (isLocked)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.lock_rounded,
                            size: 8,
                            color: AppColors.disabledColor,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Similar dramas ─────────────────────────────────────────────────────────
  Widget _buildSimilarDramas(List<Microdrama> similarDramas, String currentId) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Similar Dramas', style: text15(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: similarDramas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (_, i) {
              final item = similarDramas[i];
              return GestureDetector(
                onTap: () => _onSimilarDramaTap(item),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item.poster.isNotEmpty ? item.poster : item.banner,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          color: AppColors.cardColor,
                          child: Center(
                            child: Icon(
                              Icons.movie_outlined,
                              color: AppColors.hintTextColor,
                            ),
                          ),
                        ),
                      ),
                      // Gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.backgroundColor.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 6,
                        right: 6,
                        child: Text(
                          item.title.toUpperCase(),
                          style: text8(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Explore More ──────────────────────────────────────────────────────────
  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GestureDetector(
        onTap: () {
          // TODO: navigate to explore screen
        },
        child: Center(
          child: Text(
            'Explore More',
            style: text13(
              color: AppColors.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.overlayColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  // ── Callbacks ──────────────────────────────────────────────────────────────

  // "Start Watching" always begins from the second episode (index 1),
  // matching the free-preview-first-episode pattern used elsewhere.
  void _onStartWatching() {
    _openPlayer(initialIndex: 1);
  }

  void _toggleWatchlist() {
    setState(() => isInWatchlist = !isInWatchlist);
  }

  // Tapping a specific episode chip both highlights it and opens the
  // player starting exactly at that episode.
  void _onEpisodeTap(int index, bool isLocked) {
    setState(() => selectedEpisode = index);

    if (isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unlock this episode to watch it.')),
      );
      return;
    }

    _openPlayer(initialIndex: index);
  }

  void _openPlayer({required int initialIndex}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MicroDramaPlayerScreen(dramaId: widget.id)
      ),
    );
  }

  void _onSimilarDramaTap(Microdrama item) {
    // TODO: navigate to that drama's detail screen
  }
}

// ── Local text style helpers (already defined elsewhere) ──────────────────
// Remove these if they already exist in your project.

TextStyle text22({
  FontWeight fontWeight = FontWeight.bold,
  Color color = AppColors.textColor,
}) => appTextStyle(fontSize: 22, fontWeight: fontWeight, color: color);

TextStyle text8({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) => appTextStyle(fontSize: 8, fontWeight: fontWeight, color: color);