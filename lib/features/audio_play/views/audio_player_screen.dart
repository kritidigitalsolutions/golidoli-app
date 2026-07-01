import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/audio_play/controllers/audio_player_controller.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/utils/text_style.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioPlayerController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero(controller)),
          SliverToBoxAdapter(child: _buildNowPlaying(controller)),
          SliverToBoxAdapter(child: _buildProgressBar(controller)),
          SliverToBoxAdapter(child: _buildPlayerControls(controller)),
          SliverToBoxAdapter(child: _buildEpisodesList(controller)),
          SliverToBoxAdapter(child: _buildBackToHome()),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildHero(AudioPlayerController controller) {
    return Stack(
      children: [
        // Cover image
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Image.network(
            controller.story.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 240,
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
        // Gradient overlay
        Container(
          height: 240,
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
                  Obx(() {
                    return Column(
                      children: [
                        Text(
                          controller.story.title,
                          style: text13(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Episode ${controller.currentEpisode.episodeNumber}',
                          style: text10(color: AppColors.secondaryTextColor),
                        ),
                      ],
                    );
                  }),
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
        // Title at bottom of hero
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.story.title,
                style: text18(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                controller.story.subtitle,
                style: text12(color: AppColors.secondaryTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlaying(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        final episode = controller.currentEpisode;
        return Column(
          children: [
            Text(
              episode.title
                  .split('–')
                  .last
                  .trim()
                  .replaceAll('Ep ', 'The Beginning'),
              style: text18(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${episode.storyTitle} – Episode ${episode.episodeNumber}',
              style: text12(color: AppColors.secondaryTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProgressBar(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        return Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                activeTrackColor: AppColors.accentColor,
                inactiveTrackColor: AppColors.surfaceColor,
                thumbColor: AppColors.accentColor,
                overlayColor: AppColors.accentColor.withOpacity(0.2),
              ),
              child: Slider(
                value: controller.seekValue.value.clamp(
                  0.0,
                  controller.totalDuration.value,
                ),
                min: 0,
                max: controller.totalDuration.value,
                onChanged: controller.seekTo,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.currentPositionFormatted,
                    style: text11(color: AppColors.secondaryTextColor),
                  ),
                  Text(
                    controller.totalDurationFormatted,
                    style: text11(color: AppColors.secondaryTextColor),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlayerControls(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous episode
          GestureDetector(
            onTap: controller.playPrevious,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.skip_previous_rounded,
                color: AppColors.secondaryTextColor,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Skip backward 15s
          GestureDetector(
            onTap: controller.skipBackward,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.replay_rounded,
                    color: AppColors.secondaryTextColor,
                    size: 28,
                  ),
                  Positioned(
                    bottom: 8,
                    child: Text(
                      '15',
                      style: text8(
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Play / Pause
          Obx(
            () => GestureDetector(
              onTap: controller.togglePlayPause,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Skip forward 15s
          GestureDetector(
            onTap: controller.skipForward,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.forward_rounded,
                    color: AppColors.secondaryTextColor,
                    size: 28,
                  ),
                  Positioned(
                    bottom: 8,
                    child: Text(
                      '15',
                      style: text8(
                        color: AppColors.secondaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Next episode
          GestureDetector(
            onTap: controller.playNext,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.skip_next_rounded,
                color: AppColors.secondaryTextColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesList(AudioPlayerController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Episodes', style: text16(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Obx(() {
            return Column(
              children: List.generate(controller.story.episodes.length, (i) {
                final ep = controller.story.episodes[i];
                final isCurrentEp = controller.currentEpisodeIndex.value == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => controller.selectEpisode(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentEp
                            ? AppColors.accentColor.withOpacity(0.12)
                            : AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isCurrentEp
                              ? AppColors.accentColor.withOpacity(0.5)
                              : AppColors.borderColor.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              ep.imageUrl,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 44,
                                height: 44,
                                color: AppColors.cardColor,
                                child: Icon(
                                  Icons.headphones,
                                  color: AppColors.hintTextColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ep.title,
                                  style: text13(
                                    fontWeight: isCurrentEp
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isCurrentEp
                                        ? AppColors.white
                                        : AppColors.textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ep.fileSize,
                                  style: text11(color: AppColors.hintTextColor),
                                ),
                              ],
                            ),
                          ),
                          // Play icon
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCurrentEp
                                  ? AppColors.accentColor
                                  : AppColors.cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isCurrentEp
                                    ? AppColors.accentColor
                                    : AppColors.borderColor.withOpacity(0.4),
                              ),
                            ),
                            child: Icon(
                              isCurrentEp && controller.isPlaying.value
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBackToHome() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GestureDetector(
        onTap: () => Get.offAllNamed(AppRoutes.home),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              'Back to Home',
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
