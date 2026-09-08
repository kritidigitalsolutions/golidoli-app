import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/web/controllers/web_home_controller.dart';
import 'package:golidoli_app/web/layouts/web_main_layout.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';
import 'package:golidoli_app/web/widgets/web_content_card.dart';
import 'package:golidoli_app/web/widgets/web_content_section.dart';
import 'package:golidoli_app/web/widgets/web_hero_carousel.dart';

class WebHomeScreen extends StatelessWidget {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WebHomeController());
    final horizontalPadding = WebResponsive.contentHorizontalPadding(context);

    return WebMainLayout(
      activeRoute: WebRoutes.home,
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Spotlight Carousel
            WebHeroCarousel(
              banners: controller.banners,
              isLoading: controller.isBannersLoading.value,
            ),

            const SizedBox(height: 10),

            // Content Sections Container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Dramas Section
                  WebContentSection(
                    title: 'Trending Dramas',
                    subtitle: 'Binge addictive short vertical dramas',
                    onViewAll: () => Get.toNamed(WebRoutes.dramas),
                    isLoading: controller.isDramasLoading.value,
                    items: controller.dramas.map((drama) {
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
                  ),

                  // 3. Movies Section
                  WebContentSection(
                    title: 'Blockbuster Movies',
                    subtitle: 'Cinematic widescreen movies in HD',
                    onViewAll: () => Get.toNamed(WebRoutes.movies),
                    isLoading: controller.isMoviesLoading.value,
                    items: controller.movies.map((movie) {
                      return WebContentCard(
                        id: movie.id,
                        title: movie.title,
                        posterUrl: movie.poster.isNotEmpty ? movie.poster : movie.banner,
                        category: movie.genre.isNotEmpty ? movie.genre.first : 'Movie',
                        type: 'movie',
                        rating: movie.rating,
                        duration: movie.duration,
                        releaseYear: movie.releaseYear,
                        isPremium: movie.isPremium,
                        onTap: () => Get.toNamed(
                          '${WebRoutes.details}?id=${movie.id}&type=movie',
                          arguments: {'id': movie.id, 'type': 'movie'},
                        ),
                      );
                    }).toList(),
                  ),

                  // 4. Web Series Section
                  WebContentSection(
                    title: 'Binge-Worthy Series',
                    subtitle: 'Exciting multi-episode series and seasons',
                    onViewAll: () => Get.toNamed(WebRoutes.series),
                    isLoading: controller.isSeriesLoading.value,
                    items: controller.series.map((s) {
                      return WebContentCard(
                        id: s.id,
                        title: s.title,
                        posterUrl: s.poster.isNotEmpty ? s.poster : s.banner,
                        category: s.genre.isNotEmpty ? s.genre.first : 'Series',
                        type: 'series',
                        rating: s.rating,
                        duration: s.duration,
                        releaseYear: s.releaseYear,
                        isPremium: s.isPremium,
                        onTap: () => Get.toNamed(
                          '${WebRoutes.details}?id=${s.id}&type=series',
                          arguments: {'id': s.id, 'type': 'series'},
                        ),
                      );
                    }).toList(),
                  ),

                  // 5. Dynamic Category Rows from API
                  ...controller.categories.map((category) {
                    final items = controller.categoryContents[category.id] ?? [];
                    if (items.isEmpty) return const SizedBox.shrink();

                    return WebContentSection(
                      title: category.name,
                      items: items.map((content) {
                        final id = content.id;
                        final title = content.title;
                        final poster = content.poster.isNotEmpty ? content.poster : content.banner;
                        final type = content.type.toLowerCase();

                        return WebContentCard(
                          id: id,
                          title: title,
                          posterUrl: poster,
                          type: type.contains('drama') ? 'drama' : (type.contains('series') ? 'series' : 'movie'),
                          rating: content.rating.toDouble(),
                          isPremium: content.isPremium,
                          onTap: () => Get.toNamed(
                            '${WebRoutes.details}?id=$id&type=${type.contains("drama") ? "drama" : (type.contains("series") ? "series" : "movie")}',
                            arguments: {
                              'id': id,
                              'type': type.contains('drama') ? 'drama' : (type.contains('series') ? 'series' : 'movie'),
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
