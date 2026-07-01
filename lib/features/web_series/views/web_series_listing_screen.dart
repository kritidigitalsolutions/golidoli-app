import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/web_series/controllers/web_series_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class WebSeriesListingScreen extends StatelessWidget {
  const WebSeriesListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WebSeriesListingController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildCategoryTabs(controller),
            const SizedBox(height: 12),
            Expanded(child: _buildGrid(controller)),
            _buildExploreMore(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text('Web Series', style: text18(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(WebSeriesListingController controller) {
    return SizedBox(
      height: 36,
      child: Obx(() {
        final sel = controller.selectedCategoryIndex.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isSelected = sel == i;
            return GestureDetector(
              onTap: () => controller.onCategorySelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentColor
                      : AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accentColor
                        : AppColors.borderColor.withOpacity(0.4),
                  ),
                ),
                child: Center(
                  child: Text(
                    controller.categories[i],
                    style: text12(
                      color: isSelected
                          ? AppColors.black
                          : AppColors.secondaryTextColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildGrid(WebSeriesListingController controller) {
    return Obx(() {
      final series = controller.filteredSeries;
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: series.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (_, i) => _buildCard(series[i], controller),
      );
    });
  }

  Widget _buildCard(
    Map<String, String> item,
    WebSeriesListingController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.onSeriesTap(item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item['image']!,
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundColor.withOpacity(0.9),
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

  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              'Explore More',
              style: text13(color: AppColors.secondaryTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
