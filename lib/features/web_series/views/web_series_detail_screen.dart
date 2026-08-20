import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/web_series/controllers/series_controller.dart';
import 'package:golidoli_app/features/web_series/controllers/episode_controller.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';

import '../../../constants/enums.dart';
import '../../movie/views/movie_player_screen.dart';
import 'package:golidoli_app/features/profile/controllers/watchlist_controller.dart';

class WebSeriesDetailScreen extends StatefulWidget {
  const WebSeriesDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<WebSeriesDetailScreen> createState() => _WebSeriesDetailScreenState();
}

class _WebSeriesDetailScreenState extends State<WebSeriesDetailScreen> {
  final WatchlistController _watchlistController = Get.put(WatchlistController());
  int _selectedSeasonIndex = 0;
  final SeriesController _seriesController = Get.put(SeriesController());
  final EpisodeController _episodeController = Get.put(EpisodeController());

  @override
  void initState() {
    super.initState();
    _seriesController.fetchSeriesDetail(widget.id);
    _episodeController.fetchAllEpisodes(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        final seriesStatus = _seriesController.seriesDetailStatus.value;

        // Check for loading state
        if (seriesStatus == Status.loading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.accentColor),
            ),
          );
        }

        // Check for error state
        if (seriesStatus == Status.error) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.errorColor,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Failed to load series details",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _seriesController.fetchSeriesDetail(widget.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Get series detail with null safety
        final seriesDetail = _seriesController.seriesDetail.value;

        // Check if series detail is null
        if (seriesDetail == null) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        // Data loaded successfully
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(seriesDetail)),
              SliverToBoxAdapter(child: _buildInfo(seriesDetail)),
              SliverToBoxAdapter(child: _buildActions(seriesDetail)),
              SliverToBoxAdapter(child: _buildDownloadBtn(seriesDetail)),
              SliverToBoxAdapter(child: _buildSeasonTabs(seriesDetail)),
              SliverToBoxAdapter(child: _buildEpisodeList(seriesDetail)),
              SliverToBoxAdapter(child: _buildExploreMore()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        );
      }),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────
  Widget _buildHero(Series series) {
    return Stack(
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Image.network(
            "${AppUrl.baseUrl}${series.banner}",
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(height: 240, color: AppColors.cardColor),
          ),
        ),
        Container(
          height: 240,
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
                  _iconBtn(Icons.arrow_back_ios_new_rounded, () => Get.back()),
                  _iconBtn(Icons.share_outlined, () {}),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Info row (poster + title/rating/tags/description) ─────────────────────
  Widget _buildInfo(Series series) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "${AppUrl.baseUrl}${series.poster}",
              width: 90,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 90,
                height: 120,
                color: AppColors.cardColor,
                child: const Icon(Icons.movie, color: AppColors.hintTextColor),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(series.title, style: text18(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.ratingColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${series.rating}',
                      style: text13(
                        color: AppColors.ratingColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'totalReviews',
                      style: text11(color: AppColors.hintTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: series.genre
                      .map((genre) => _buildTag(genre))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  series.description,
                  style: text12(color: AppColors.secondaryTextColor),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String genre) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Text(genre, style: text10(color: AppColors.secondaryTextColor)),
    );
  }

  // ── Action buttons ─────────────────────────────────────────────────────────
  Widget _buildActions(Series series) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final episodes = _episodeController.allEpisode.value?.episodes;
                if (episodes != null && episodes.isNotEmpty) {
                  final sorted = List<Episode>.from(episodes)
                    ..sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
                  final firstEp = sorted.first;
                  final isPremium = series.isPremium;
                  final title = series.title;
                  if (checkPlayable(context, isPremium: isPremium, title: title)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MoviePlayerScreen(
                          episodeId: firstEp.id,
                          title: "${series.title} - EP ${firstEp.episodeNumber}",
                        ),
                      ),
                    );
                  }
                } else {
                  Get.snackbar(
                    'Notice',
                    'No episodes available yet',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                }
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Watch Now',
                      style: text13(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              final bool isInWatchlist =
                  widget.id.isNotEmpty && _watchlistController.isItemInWatchlist(widget.id);
              final bool isLoading =
                  widget.id.isNotEmpty && _watchlistController.isItemLoading(widget.id);

              return GestureDetector(
                onTap: () {
                  if (widget.id.isNotEmpty && !isLoading) {
                    _watchlistController.toggleWatchlist(widget.id);
                  }
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.borderColor.withOpacity(0.5),
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          )
                        : Row(
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
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadBtn(Series series) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.download_outlined,
                color: AppColors.secondaryTextColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Download',
                style: text13(
                  color: AppColors.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Season tabs ────────────────────────────────────────────────────────────
  Widget _buildSeasonTabs(Series series) {
    if (series.seasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(series.seasons.length, (index) {
            final season = series.seasons[index];
            String seasonName;

            if (season is Map<String, dynamic>) {
              seasonName = season['name'] ?? 'Season ${index + 1}';
            } else {
              seasonName = (season as dynamic).name ?? 'Season ${index + 1}';
            }

            return Padding(
              padding: EdgeInsets.only(
                right: index < series.seasons.length - 1 ? 16 : 0,
              ),
              child: _seasonTab(seasonName, index),
            );
          }),
        ),
      ),
    );
  }

  Widget _seasonTab(String label, int index) {
    final isSelected = _selectedSeasonIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSeasonIndex = index;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text14(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.textColor
                  : AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isSelected ? 60 : 0,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  // ── Episode list with GetX ──────────────────────────────────────────────
  Widget _buildEpisodeList(Series series) {
    final seasonNumber = _selectedSeasonIndex + 1;
    final status = _episodeController.allEpisodeStatus.value;

    if (status == Status.loading) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accentColor),
        ),
      );
    }

    if (status == Status.error) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Center(
          child: Text(
            'Failed to load episodes',
            style: text14(color: AppColors.errorColor),
          ),
        ),
      );
    }

    final allEpisodes = _episodeController.allEpisode.value;

    if (allEpisodes == null || allEpisodes.episodes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Center(
          child: Text(
            'No episodes available',
            style: text14(color: AppColors.secondaryTextColor),
          ),
        ),
      );
    }

    final filteredEpisodes = allEpisodes.episodes
        .where((ep) => ep.seasonNumber == seasonNumber)
        .toList();

    if (filteredEpisodes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Center(
          child: Text(
            'No episodes available for Season $seasonNumber',
            style: text14(color: AppColors.secondaryTextColor),
          ),
        ),
      );
    }

    filteredEpisodes.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: filteredEpisodes.map((ep) => _buildEpisodeTile(ep)).toList(),
      ),
    );
  }

  Widget _buildEpisodeTile(Episode ep) {
    return GestureDetector(
      onTap: () {
        final series = _seriesController.seriesDetail.value;
        final isPremium = series?.isPremium ?? false;
        final title = series?.title;
        if (checkPlayable(context, isPremium: isPremium, title: title)) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MoviePlayerScreen(episodeId: ep.id),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ep.thumbnail.isNotEmpty
                    ? "${AppUrl.baseUrl}${ep.thumbnail}"
                    : '',
                width: 70,
                height: 46,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 70,
                  height: 46,
                  color: AppColors.cardColor,
                  child: const Icon(
                    Icons.play_circle,
                    color: AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ep.title,
                    style: text13(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        'S${ep.seasonNumber.toString().padLeft(2, '0')}:E${ep.episodeNumber.toString().padLeft(2, '0')}',
                        style: text11(color: AppColors.hintTextColor),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ep.duration,
                        style: text11(color: AppColors.hintTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.black,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () {},
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

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.overlayColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }
}
