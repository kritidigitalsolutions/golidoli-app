import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/audio_play/controllers/audio_stories_controller.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/utils/text_style.dart';

class AudioStoriesScreen extends StatelessWidget {
  const AudioStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioStoriesController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildCategoryTabs(controller)),
            SliverToBoxAdapter(child: _buildHeroBanner(controller)),
            SliverToBoxAdapter(
              child: _buildSection(
                'Top Audio Stories',
                controller.topAudioStories,
                controller,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                'Romantic Audio Stories',
                controller.romanticAudioStories,
                controller,
              ),
            ),
            SliverToBoxAdapter(child: _buildExploreMore()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

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
          Text('Audio Stories', style: text18(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(AudioStoriesController controller) {
    return SizedBox(
      height: 38,
      child: Obx(() {
        final selected = controller.selectedCategoryIndex.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isSelected = selected == i;
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

  Widget _buildHeroBanner(AudioStoriesController controller) {
    final story = controller.heroBanner;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: GestureDetector(
        onTap: () => controller.onStoryTap(story),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                story.imageUrl,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 190,
                  color: AppColors.cardColor,
                  child: Center(
                    child: Icon(
                      Icons.headphones,
                      color: AppColors.hintTextColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Container(
                height: 190,
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
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: text18(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      story.subtitle,
                      style: text12(color: AppColors.secondaryTextColor),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => controller.onStoryTap(story),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Play Now',
                              style: text11(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildSection(
    String title,
    List<AudioStoryModel> stories,
    AudioStoriesController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: text16(fontWeight: FontWeight.bold)),
                Text('View All', style: text12(color: AppColors.accentColor)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: stories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                return _buildStoryCard(stories[i], controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(
    AudioStoryModel story,
    AudioStoriesController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.onStoryTap(story),
      child: SizedBox(
        width: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  story.imageUrl,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.cardColor,
                    child: Center(
                      child: Icon(
                        Icons.headphones,
                        color: AppColors.hintTextColor,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              story.title,
              style: text10(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              story.subtitle,
              style: text9(color: AppColors.hintTextColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreMore() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
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

// local text9 helper
TextStyle text9({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) {
  return appTextStyle(fontSize: 9, fontWeight: fontWeight, color: color);
}
