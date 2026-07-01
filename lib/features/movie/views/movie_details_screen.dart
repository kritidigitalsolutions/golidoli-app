import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/movie/controllers/movie_details_controller.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailController());
    final movie = controller.movie;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(controller, movie)),
          SliverToBoxAdapter(child: _buildMovieInfo(controller, movie)),
          SliverToBoxAdapter(child: _buildActions(controller)),
          SliverToBoxAdapter(child: _buildMoreLikeThis(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHero(DetailController controller, Map<String, dynamic> movie) {
    return Stack(
      children: [
        // Backdrop image
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Image.network(
            movie['backdrop'],
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.cardColor),
          ),
        ),
        // Gradient overlay
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
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.watchNow,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(
    DetailController controller,
    Map<String, dynamic> movie,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              movie['image'],
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
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: text20(fontWeight: FontWeight.bold),
                ),
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
                      '${movie['rating']}',
                      style: text13(
                        color: AppColors.ratingColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${movie['reviews']})',
                      style: text12(color: AppColors.hintTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (movie['tags'] as List<String>)
                      .map((tag) => _buildTag(tag))
                      .toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  movie['description'],
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

  Widget _buildActions(DetailController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            // Watch Now + Watchlist row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.videoPlayer);
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
            const SizedBox(height: 10),
            // Download button
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.borderColor.withOpacity(0.4),
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildMoreLikeThis(DetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('More Like This', style: text16(fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.moreLikeThis.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (_, i) {
              final item = controller.moreLikeThis[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.cardColor,
                    child: Center(
                      child: Icon(Icons.movie, color: AppColors.hintTextColor),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          GestureDetector(
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
        ],
      ),
    );
  }
}
