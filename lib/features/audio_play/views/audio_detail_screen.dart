import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/audio_play/controllers/audio_detail_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class AudioDetailScreen extends StatelessWidget {
  const AudioDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioDetailController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(controller)),
          SliverToBoxAdapter(child: _buildStoryInfo(controller)),
          SliverToBoxAdapter(child: _buildPlayButton(controller)),
          SliverToBoxAdapter(child: _buildMoreLikeThis(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHero(AudioDetailController controller) {
    return Stack(
      children: [
        // Cover image
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Image.network(
            controller.story.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 260,
              color: AppColors.cardColor,
              child: Center(
                child: Icon(
                  Icons.headphones,
                  color: AppColors.hintTextColor,
                  size: 60,
                ),
              ),
            ),
          ),
        ),
        // Gradient bottom overlay
        Container(
          height: 260,
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
                    onTap: () {},
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
        // Title overlay at bottom
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.story.title,
                style: text20(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                controller.story.subtitle,
                style: text13(color: AppColors.secondaryTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryInfo(AudioDetailController controller) {
    final story = controller.story;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              _buildStat(
                Icons.headphones_rounded,
                '${_formatPlays(story.totalPlays)} Plays',
                AppColors.secondaryTextColor,
              ),
              const SizedBox(width: 16),
              _buildStat(
                Icons.star_rounded,
                '${story.rating}',
                AppColors.ratingColor,
              ),
              const SizedBox(width: 16),
              _buildStat(
                Icons.queue_music_rounded,
                '${story.totalEpisodes} Episodes',
                AppColors.secondaryTextColor,
              ),
              const SizedBox(width: 16),
              _buildStat(
                Icons.access_time_rounded,
                story.duration,
                AppColors.secondaryTextColor,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Description
          Obx(() {
            final showFull = controller.showFullDescription.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.description,
                  style: text13(color: AppColors.secondaryTextColor),
                  maxLines: showFull ? null : 2,
                  overflow: showFull ? null : TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: controller.toggleDescription,
                  child: Text(
                    showFull ? 'Show Less' : 'Show More',
                    style: text12(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label, style: text11(color: color)),
      ],
    );
  }

  Widget _buildPlayButton(AudioDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: controller.onPlayNow,
        child: Container(
          height: 48,
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
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                'Play Now',
                style: text14(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreLikeThis(AudioDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'You May Also Like',
                style: text16(fontWeight: FontWeight.bold),
              ),
              Text('View All', style: text12(color: AppColors.accentColor)),
            ],
          ),
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
              return GestureDetector(
                onTap: () => controller.onMoreLikeThisTap(item),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.cardColor,
                      child: Center(
                        child: Icon(
                          Icons.headphones,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatPlays(int plays) {
    if (plays >= 1000) {
      return '${(plays / 1000).toStringAsFixed(1)}K';
    }
    return '$plays';
  }
}
