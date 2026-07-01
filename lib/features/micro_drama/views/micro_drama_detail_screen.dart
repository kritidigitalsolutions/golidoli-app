import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_detail_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MicroDramaDetailScreen extends StatelessWidget {
  const MicroDramaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MicroDramaDetailController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(controller)),
          SliverToBoxAdapter(child: _buildRatingAndTags(controller)),
          SliverToBoxAdapter(child: _buildStory(controller)),
          SliverToBoxAdapter(child: _buildActions(controller)),
          SliverToBoxAdapter(child: _buildEpisodes(controller)),
          SliverToBoxAdapter(child: _buildSimilarDramas(controller)),
          SliverToBoxAdapter(child: _buildExplorMore(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // ── Hero cover ─────────────────────────────────────────────────────────────
  Widget _buildHero(MicroDramaDetailController controller) {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: Image.network(
            controller.drama.imageUrl,
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
                  _iconBtn(Icons.arrow_back_ios_new_rounded, () => Get.back()),
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
            controller.drama.title,
            style: text22(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ── Rating & tags ──────────────────────────────────────────────────────────
  Widget _buildRatingAndTags(MicroDramaDetailController controller) {
    final drama = controller.drama;
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
                '${drama.rating}',
                style: text12(
                  color: AppColors.ratingColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '(${_formatNum(drama.totalReviews)})',
                style: text11(color: AppColors.hintTextColor),
              ),
            ],
          ),
          ...drama.tags.map((tag) => _buildTag(tag)),
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
  Widget _buildStory(MicroDramaDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Story', style: text15(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            controller.drama.story,
            style: text13(color: AppColors.secondaryTextColor),
          ),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  Widget _buildActions(MicroDramaDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(
        () => Row(
          children: [
            // Start Watching
            Expanded(
              child: GestureDetector(
                onTap: controller.onStartWatching,
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
                onTap: controller.toggleWatchlist,
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
      ),
    );
  }

  // ── Episodes grid ──────────────────────────────────────────────────────────
  Widget _buildEpisodes(MicroDramaDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Episodes', style: text15(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Obx(() {
            final eps = controller.visibleEpisodes;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(eps.length, (i) {
                final ep = eps[i];
                final isSelected = controller.selectedEpisode.value == i;
                return GestureDetector(
                  onTap: () => controller.onEpisodeTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentColor
                          : ep.isLocked
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
                          'E${ep.episodeNumber}',
                          style: text12(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : ep.isLocked
                                ? AppColors.disabledColor
                                : AppColors.textColor,
                          ),
                        ),
                        if (ep.isLocked)
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
            );
          }),
        ],
      ),
    );
  }

  // ── Similar dramas ─────────────────────────────────────────────────────────
  Widget _buildSimilarDramas(MicroDramaDetailController controller) {
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
            itemCount: controller.similarDramas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (_, i) {
              final item = controller.similarDramas[i];
              return GestureDetector(
                onTap: () => controller.onSimilarDramaTap(item),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        item.imageUrl,
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
  Widget _buildExplorMore(MicroDramaDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
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
}

// Local text helpers
TextStyle text22({
  FontWeight fontWeight = FontWeight.bold,
  Color color = AppColors.textColor,
}) => appTextStyle(fontSize: 22, fontWeight: fontWeight, color: color);

TextStyle text8({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) => appTextStyle(fontSize: 8, fontWeight: fontWeight, color: color);
