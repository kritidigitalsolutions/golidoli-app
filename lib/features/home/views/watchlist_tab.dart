import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WatchlistController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabs(controller),
            Expanded(child: _buildContent(controller)),
          ],
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
    return Column(
      children: [
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            final items = controller.currentList;
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (_, i) => _buildCard(items[i]),
            );
          }),
        ),
        _buildAddMoreButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCard(Map<String, String> item) {
    return ClipRRect(
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
                child: Icon(Icons.movie, color: AppColors.hintTextColor),
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
    );
  }

  Widget _buildAddMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {},
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
