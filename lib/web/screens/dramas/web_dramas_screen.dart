import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/web/controllers/web_content_controller.dart';
import 'package:golidoli_app/web/layouts/web_main_layout.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';
import 'package:golidoli_app/web/widgets/web_content_card.dart';
import 'package:golidoli_app/web/widgets/web_responsive_grid.dart';
import 'package:golidoli_app/web/widgets/web_shimmer.dart';

class WebDramasScreen extends StatelessWidget {
  const WebDramasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WebContentController());
    final horizontalPadding = WebResponsive.contentHorizontalPadding(context);

    return WebMainLayout(
      activeRoute: WebRoutes.dramas,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Row(
              children: [
                Container(
                  width: 5,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Micro Dramas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Binge addictive short-form dramas with thrilling episodes and stories.',
              style: TextStyle(
                color: AppColors.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Genre Filter Chips
            Obx(() {
              final genres = controller.dramaGenres;
              final selected = controller.selectedDramaGenre.value;
              if (genres.length <= 1) return const SizedBox.shrink();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: genres.map((genre) {
                    final isSelected = selected.toLowerCase() == genre.toLowerCase();

                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            controller.selectedDramaGenre.value = genre;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryPink
                                  : AppColors.surfaceColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryPink
                                    : AppColors.borderColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            const SizedBox(height: 28),

            // Content Grid
            Obx(() {
              if (controller.isDramasLoading.value) {
                return WebResponsiveGrid(
                  children: List.generate(12, (_) => const WebShimmerCard()),
                );
              }

              final dramas = controller.filteredDramas;
              if (dramas.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.0),
                    child: Column(
                      children: [
                        Icon(Icons.video_library_outlined,
                            color: AppColors.secondaryTextColor, size: 56),
                        SizedBox(height: 16),
                        Text(
                          'No dramas found in this category',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return WebResponsiveGrid(
                children: dramas.map((drama) {
                  return WebContentCard(
                    id: drama.id,
                    title: drama.title,
                    posterUrl: drama.poster.isNotEmpty ? drama.poster : drama.banner,
                    category: drama.genre.isNotEmpty ? drama.genre.first.toString() : 'Drama',
                    type: 'drama',
                    rating: drama.rating.toDouble(),
                    duration: drama.duration,
                    releaseYear: drama.releaseYear,
                    isPremium: drama.isPremium,
                    onTap: () => Get.toNamed(
                      '${WebRoutes.details}?id=${drama.id}&type=drama',
                      arguments: {'id': drama.id, 'type': 'drama'},
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
