import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/home/controllers/home_controller.dart';
import 'package:golidoli_app/features/micro_drama/views/micro_drama_detail_screen.dart';
import 'package:golidoli_app/features/movie/views/movie_details_screen.dart';
import 'package:golidoli_app/features/profile/controllers/watchlist_controller.dart';
import 'package:golidoli_app/features/profile/models/response/watchlist_model.dart';
import 'package:golidoli_app/features/web_series/views/web_series_detail_screen.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WatchlistController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchWatchlist,
          color: AppColors.primaryColor,
          backgroundColor: AppColors.surfaceColor,
          child: Column(
            children: [
              _buildAppBar(),
              _buildTabs(controller),
              Expanded(child: _buildContent(controller)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          Text(
            'Watchlist',
            style: text18(
              fontWeight: FontWeight.bold,
              color: AppColors.buttonColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab row ────────────────────────────────────────────────────────────────
  Widget _buildTabs(WatchlistController controller) {
    return Obx(() {
      final sel = controller.selectedTabIndex.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(controller.tabs.length, (i) {
            final isSelected = sel == i;
            return GestureDetector(
              onTap: () => controller.selectTab(i),
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.tabs[i],
                      style: text14(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.accentColor
                            : AppColors.secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: isSelected ? 40 : 0,
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  // ── Grid content ───────────────────────────────────────────────────────────
  Widget _buildContent(WatchlistController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.allItems.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      final items = controller.currentList;

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border_rounded,
                size: 54,
                color: AppColors.hintTextColor,
              ),
              const SizedBox(height: 12),
              Text(
                'Your watchlist is empty',
                style: text14(
                  color: AppColors.secondaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Save movies & shows to watch them later',
                style: text12(color: AppColors.hintTextColor),
              ),
              const SizedBox(height: 20),
              _buildAddMoreButton(),
            ],
          ),
        );
      }

      return Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, i) =>
                  _buildCard(context, controller, items[i]),
            ),
          ),
          _buildAddMoreButton(),
          const SizedBox(height: 20),
        ],
      );
    });
  }

  Widget _buildCard(
    BuildContext context,
    WatchlistController controller,
    WatchlistItem item,
  ) {
    final media = item.item;
    final rawUrl = (media?.poster != null && media!.poster!.isNotEmpty)
        ? media.poster!
        : (media?.banner != null && media!.banner!.isNotEmpty)
        ? media.banner!
        : '';
    final imageUrl = formatMediaUrl(rawUrl);

    return GestureDetector(
      onTap: () => _navigateToDetail(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildPlaceholder(),
              )
            else
              _buildPlaceholder(),

            // Top right delete button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  if (item.id != null) {
                    Get.defaultDialog(
                      title: 'Remove',
                      middleText:
                          'Remove "${media?.title ?? 'Item'}" from watchlist?',
                      textConfirm: 'Remove',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.red,
                      onConfirm: () {
                        Get.back();
                        controller.removeFromWatchlist(item.id!);
                      },
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),

            // Gradient + Watch Now label at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundColor.withOpacity(0.95),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Watch Now',
                      style: text9(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.cardColor,
      child: const Center(
        child: Icon(Icons.movie, color: AppColors.hintTextColor),
      ),
    );
  }

  void _navigateToDetail(WatchlistItem item) {
    final media = item.item;
    final id = media?.id ?? '';
    if (id.isEmpty) return;

    final model = item.itemModel?.toLowerCase() ?? '';
    if (model == 'movie' || model == 'movies') {
      Get.to(() => MovieDetailsScreen(id: id));
    } else if (model == 'series' ||
        model == 'web_series' ||
        model == 'webseries') {
      Get.to(() => WebSeriesDetailScreen(id: id));
    } else {
      Get.to(() => MicroDramaDetailScreen(id: id));
    }
  }

  Widget _buildAddMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          try {
            final homeController = Get.find<HomeController>();
            homeController.pageIndex.value = 0;
          } catch (_) {}
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '+ Add More',
              style: text15(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle text9({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) => appTextStyle(fontSize: 9, fontWeight: fontWeight, color: color);
