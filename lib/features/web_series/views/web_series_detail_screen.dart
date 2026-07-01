import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/web_series/controllers/web_series_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class WebSeriesDetailScreen extends StatelessWidget {
  const WebSeriesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WebSeriesDetailController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(controller)),
          SliverToBoxAdapter(child: _buildInfo(controller)),
          SliverToBoxAdapter(child: _buildActions(controller)),
          SliverToBoxAdapter(child: _buildDownloadBtn(controller)),
          SliverToBoxAdapter(child: _buildSeasonTabs(controller)),
          SliverToBoxAdapter(child: _buildEpisodeList(controller)),
          SliverToBoxAdapter(child: _buildExploreMore()),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────
  Widget _buildHero(WebSeriesDetailController controller) {
    return Stack(
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Image.network(
            controller.series.imageUrl,
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
  Widget _buildInfo(WebSeriesDetailController controller) {
    final s = controller.series;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              s.imageUrl,
              width: 90,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 90,
                height: 120,
                color: AppColors.cardColor,
                child: Icon(Icons.movie, color: AppColors.hintTextColor),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title, style: text18(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                // Rating
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.ratingColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${s.rating}',
                      style: text13(
                        color: AppColors.ratingColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${_fmtNum(s.totalReviews)})',
                      style: text11(color: AppColors.hintTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: s.tags.map((t) => _buildTag(t)).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  s.description,
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

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      child: Text(label, style: text10(color: AppColors.secondaryTextColor)),
    );
  }

  // ── Action buttons ─────────────────────────────────────────────────────────
  Widget _buildActions(WebSeriesDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: controller.onWatchNow,
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
              child: GestureDetector(
                onTap: controller.toggleWatchlist,
                child: Container(
                  height: 44,
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
                        controller.isInWatchlist.value
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_add_outlined,
                        color: controller.isInWatchlist.value
                            ? AppColors.primaryColor
                            : AppColors.secondaryTextColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.isInWatchlist.value
                            ? 'Saved'
                            : '+ Watchlist',
                        style: text13(
                          color: controller.isInWatchlist.value
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadBtn(WebSeriesDetailController controller) {
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
              Icon(
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
  Widget _buildSeasonTabs(WebSeriesDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Obx(() {
        return Row(
          children: [
            _seasonTab('Season 1', 0, controller),
            const SizedBox(width: 16),
            _seasonTab('Season 2', 1, controller),
          ],
        );
      }),
    );
  }

  Widget _seasonTab(
    String label,
    int index,
    WebSeriesDetailController controller,
  ) {
    final isSelected = controller.selectedSeason.value == index;
    return GestureDetector(
      onTap: () => controller.selectSeason(index),
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

  // ── Episode list ──────────────────────────────────────────────────────────
  Widget _buildEpisodeList(WebSeriesDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Obx(() {
        final eps = controller.currentEpisodes;
        return Column(
          children: eps.map((ep) => _buildEpisodeTile(ep, controller)).toList(),
        );
      }),
    );
  }

  Widget _buildEpisodeTile(
    WebSeriesEpisode ep,
    WebSeriesDetailController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.onEpisodeTap(ep),
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
                ep.thumbnailUrl,
                width: 70,
                height: 46,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 70,
                  height: 46,
                  color: AppColors.cardColor,
                  child: Icon(
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
                  Text(ep.title, style: text13(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    ep.duration,
                    style: text11(color: AppColors.hintTextColor),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
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
        decoration: BoxDecoration(
          color: AppColors.overlayColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 18),
      ),
    );
  }

  String _fmtNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}
