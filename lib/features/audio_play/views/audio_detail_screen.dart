import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/audio_play/controllers/audio_detail_controller.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/utils/text_style.dart';

class AudioDetailScreen extends StatelessWidget {
  const AudioDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioDetailController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value && controller.story.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }

        final story = controller.story.value;
        if (story == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.hintTextColor, size: 48),
                const SizedBox(height: 12),
                Text('Audio Story not found', style: text14(color: AppColors.secondaryTextColor)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                  child: Text('Go Back', style: text12(color: AppColors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero(controller, story)),
            SliverToBoxAdapter(child: _buildStoryInfo(controller, story)),
            SliverToBoxAdapter(child: _buildPlayButton(context, controller)),
            if (story.episodes.isNotEmpty)
              SliverToBoxAdapter(child: _buildEpisodesSection(context, controller, story)),
            if (controller.moreLikeThis.isNotEmpty)
              SliverToBoxAdapter(child: _buildMoreLikeThis(controller)),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        );
      }),
    );
  }

  Widget _buildHero(AudioDetailController controller, AudioStoryModel story) {
    return Stack(
      children: [
        // Cover image
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Image.network(
            story.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 260,
              color: AppColors.cardColor,
              child: const Center(
                child: Icon(Icons.headphones_rounded, color: AppColors.hintTextColor, size: 60),
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
              colors: [
                Colors.transparent,
                AppColors.backgroundColor.withValues(alpha: 0.95),
              ],
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
                      decoration: const BoxDecoration(
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
                  if (story.isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.accentColor, Color(0xFFFF5E97)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'PREMIUM',
                            style: text10(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
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
                story.title,
                style: appTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                story.subtitle,
                style: text13(color: AppColors.secondaryTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryInfo(AudioDetailController controller, AudioStoryModel story) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStat(
                Icons.headphones_rounded,
                '${_formatPlays(story.totalPlays)} Plays',
                AppColors.secondaryTextColor,
              ),
              _buildStat(
                Icons.star_rounded,
                '${story.rating}',
                AppColors.ratingColor,
              ),
              _buildStat(
                Icons.queue_music_rounded,
                '${story.totalEpisodes} Episodes',
                AppColors.secondaryTextColor,
              ),
              _buildStat(
                Icons.language_rounded,
                story.language,
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
                  story.description.isNotEmpty
                      ? story.description
                      : 'Listen to the full audio story experience on GoliDoli.',
                  style: text13(color: AppColors.secondaryTextColor),
                  maxLines: showFull ? null : 2,
                  overflow: showFull ? null : TextOverflow.ellipsis,
                ),
                if (story.description.length > 100) ...[
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
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label, style: text11(color: color)),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context, AudioDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () => controller.onPlayNow(context),
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
                size: 24,
              ),
              const SizedBox(width: 6),
              Text(
                'Play Now',
                style: text15(
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

  Widget _buildEpisodesSection(
    BuildContext context,
    AudioDetailController controller,
    AudioStoryModel story,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Episodes', style: text16(fontWeight: FontWeight.bold)),
              Text('${story.episodes.length} Total', style: text12(color: AppColors.hintTextColor)),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: story.episodes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final ep = story.episodes[index];
              return GestureDetector(
                onTap: () => controller.playEpisode(context, index),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${ep.episodeNumber}',
                            style: text13(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ep.title,
                              style: text13(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatEpisodeDuration(ep.durationSeconds),
                              style: text11(color: AppColors.secondaryTextColor),
                            ),
                          ],
                        ),
                      ),
                      if (ep.isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.accentColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            'PREMIUM',
                            style: appTextStyle(
                              fontSize: 9,
                              color: AppColors.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primaryColor,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoreLikeThis(AudioDetailController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You May Also Like',
            style: text16(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.moreLikeThis.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, i) {
              final item = controller.moreLikeThis[i];
              return GestureDetector(
                onTap: () => controller.onMoreLikeThisTap(item),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: AppColors.cardColor,
                            child: const Center(
                              child: Icon(Icons.headphones_rounded, color: AppColors.hintTextColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: text10(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatPlays(int plays) {
    if (plays >= 1000000) {
      return '${(plays / 1000000).toStringAsFixed(1)}M';
    } else if (plays >= 1000) {
      return '${(plays / 1000).toStringAsFixed(1)}K';
    }
    return '$plays';
  }

  String _formatEpisodeDuration(int totalSeconds) {
    if (totalSeconds <= 0) return 'Audio Episode';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} mins';
  }
}
