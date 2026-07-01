import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_controller.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/utils/text_style.dart';

class MicroDramaScreen extends StatelessWidget {
  const MicroDramaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MicroDramaController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildCategoryTabs(controller)),
            SliverToBoxAdapter(child: _buildHeroBanner(controller)),
            SliverToBoxAdapter(child: _buildDramaGrid(controller)),
            SliverToBoxAdapter(child: _buildExploreMore()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderColor.withOpacity(0.4),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text('Micro Dramas', style: text18(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ── Category chips ─────────────────────────────────────────────────────────
  Widget _buildCategoryTabs(MicroDramaController controller) {
    return SizedBox(
      height: 38,
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
                  vertical: 3,
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

  // ── Hero banner (first drama) ─────────────────────────────────────────────
  Widget _buildHeroBanner(MicroDramaController controller) {
    final drama = controller.heroDrama;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: GestureDetector(
        onTap: () => controller.onDramaTap(drama),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                drama.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 200,
                  color: AppColors.cardColor,
                  child: Center(
                    child: Icon(
                      Icons.movie_outlined,
                      color: AppColors.hintTextColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundColor.withOpacity(0.92),
                    ],
                  ),
                ),
              ),
              // Title at bottom
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drama.title,
                      style: text20(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      drama.subtitle,
                      style: text12(color: AppColors.secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Drama grid  ────────────────────────────────────────────────────────────
  Widget _buildDramaGrid(MicroDramaController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        final dramas = controller.filteredDramas;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dramas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (_, i) => _buildDramaCard(dramas[i], controller),
        );
      }),
    );
  }

  Widget _buildDramaCard(
    MicroDramaModel drama,
    MicroDramaController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.onDramaTap(drama),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              drama.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: AppColors.cardColor,
                child: Center(
                  child: Icon(
                    Icons.movie_outlined,
                    color: AppColors.hintTextColor,
                    size: 32,
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
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
            // Title
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Text(
                drama.title.toUpperCase(),
                style: text10(fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Explore more ──────────────────────────────────────────────────────────
  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              'Explore More',
              style: text13(
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
