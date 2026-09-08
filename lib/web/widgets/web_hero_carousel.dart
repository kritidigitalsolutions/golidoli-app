import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/home/models/home_banner_model.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/utils/web_auth_guard.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';
import 'package:golidoli_app/web/widgets/web_shimmer.dart';

class WebHeroCarousel extends StatefulWidget {
  final List<HomeBannerItem> banners;
  final bool isLoading;

  const WebHeroCarousel({
    super.key,
    required this.banners,
    this.isLoading = false,
  });

  @override
  State<WebHeroCarousel> createState() => _WebHeroCarouselState();
}

class _WebHeroCarouselState extends State<WebHeroCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onWatchNow(HomeBannerItem banner) {
    final targetId = banner.content?.id ?? banner.id;
    final targetType = (banner.contentType ?? 'movie').toLowerCase();

    if (targetId != null && targetId.isNotEmpty) {
      WebAuthGuard.requireAuth(
        context: context,
        message: 'Please sign in to view details and watch on GoliDoli.',
        onSuccess: () {
          Get.toNamed(
            '${WebRoutes.details}?id=$targetId&type=$targetType',
            arguments: {'id': targetId, 'type': targetType},
          );
        },
      );
    }
  }

  DateTime? _lastKeyEventTime;
  LogicalKeyboardKey? _lastKeyEventKey;

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;

    final now = DateTime.now();
    // Throttle carousel slide switching to 350ms so long press advances smoothly without spastic skipping
    if (_lastKeyEventKey == event.logicalKey &&
        _lastKeyEventTime != null &&
        now.difference(_lastKeyEventTime!).inMilliseconds < 350) {
      return;
    }

    _lastKeyEventTime = now;
    _lastKeyEventKey = event.logicalKey;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      _carouselController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _carouselController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = WebResponsive.isMobile(context);
    final isTablet = WebResponsive.isTablet(context);
    final double bannerHeight = isMobile ? 320.0 : (isTablet ? 420.0 : 520.0);

    if (widget.isLoading) {
      return WebShimmerBanner(height: bannerHeight);
    }

    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return MouseRegion(
      onEnter: (_) {
        if (_focusNode.canRequestFocus) {
          _focusNode.requestFocus();
        }
      },
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: widget.banners.length,
              options: CarouselOptions(
                height: bannerHeight,
                viewportFraction: 1.0,
                autoPlay: widget.banners.length > 1,
                autoPlayInterval: const Duration(seconds: 6),
                autoPlayAnimationDuration: const Duration(milliseconds: 900),
                autoPlayCurve: Curves.easeInOutCubic,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final banner = widget.banners[index];
                final imageUrl = formatMediaUrl(
                  banner.banner ??
                      banner.content?.banner ??
                      banner.content?.poster,
                );
                final description = banner.content?.storyline ?? '';

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Background Backdrop Image
                    if (imageUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        placeholder: (_, __) =>
                            Container(color: AppColors.surfaceColor),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceColor,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.secondaryTextColor,
                              size: 60,
                            ),
                          ),
                        ),
                      )
                    else
                      Container(color: AppColors.surfaceColor),

                    // 2. Cinematic Gradients
                    // // Left-to-Right dark vignette for text readability
                    // Positioned.fill(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         begin: Alignment.centerLeft,
                    //         end: Alignment.centerRight,
                    //         colors: [
                    //           AppColors.backgroundColor,
                    //           AppColors.backgroundColor.withOpacity(0.9),
                    //           AppColors.backgroundColor.withOpacity(0.5),
                    //           Colors.transparent,
                    //         ],
                    //         stops: const [0.0, 0.35, 0.65, 1.0],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Bottom-to-Top fade into page background
                    // Positioned.fill(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         begin: Alignment.bottomCenter,
                    //         end: Alignment.topCenter,
                    //         colors: [
                    //           AppColors.backgroundColor,
                    //           AppColors.backgroundColor.withOpacity(0.7),
                    //           Colors.transparent,
                    //         ],
                    //         stops: const [0.0, 0.25, 0.6],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // 3. Hero Content Information
                    Positioned(
                      left: WebResponsive.contentHorizontalPadding(context),
                      right: isMobile
                          ? 20
                          : (MediaQuery.sizeOf(context).width * 0.4),
                      bottom: isMobile ? 36 : 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Featured Pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.primaryPink.withOpacity(0.6),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.stars_rounded,
                                  color: AppColors.primaryPink,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  (banner.contentType ?? 'FEATURED')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primaryPink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Title
                          Text(
                            banner.title ??
                                banner.content?.title ??
                                'Experience Great Cinema',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: isMobile ? 24 : (isTablet ? 32 : 42),
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Description
                          if (description.isNotEmpty && !isMobile)
                            Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.85),
                                fontSize: isTablet ? 13 : 15,
                                height: 1.4,
                              ),
                            ),
                          const SizedBox(height: 20),

                          // Action Buttons
                          Wrap(
                            spacing: 14,
                            runSpacing: 10,
                            children: [
                              // Watch Now Button
                              ElevatedButton.icon(
                                onPressed: () => _onWatchNow(banner),
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Watch Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPink,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 6,
                                  shadowColor: AppColors.primaryPink
                                      .withOpacity(0.5),
                                ),
                              ),

                              // Details Button
                              OutlinedButton.icon(
                                onPressed: () => _onWatchNow(banner),
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'More Details',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.12,
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // Carousel Indicator Dots
            if (widget.banners.length > 1)
              Positioned(
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.banners.asMap().entries.map((entry) {
                    final isSelected = _currentIndex == entry.key;
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 24.0 : 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryPink
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
