import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/movie/controllers/movie_player_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:video_player/video_player.dart';

class MoviePlayerScreen extends StatelessWidget {
  MoviePlayerScreen({super.key});

  final MoviePlayerController controller = Get.put(MoviePlayerController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final title = args?['title'] as String? ?? 'GoliDoli Player';

    return Scaffold(
      backgroundColor: AppColors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;
          return SafeArea(
            top: !isLandscape,
            bottom: !isLandscape,
            child: Column(
              children: [
                if (!isLandscape) _TopBar(title: title),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: isLandscape ? 16 / 9 : 16 / 9,
                      child: _PlayerSurface(
                        title: title,
                        showOverlayHeader: isLandscape,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;

  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: text16(fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerSurface extends StatelessWidget {
  final String title;
  final bool showOverlayHeader;

  _PlayerSurface({required this.title, required this.showOverlayHeader});

  final MoviePlayerController controller = Get.find<MoviePlayerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: controller.toggleControls,
        child: Container(
          color: AppColors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (controller.isInitialized.value)
                FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: controller.videoController.value.size.width,
                    height: controller.videoController.value.size.height,
                    child: VideoPlayer(controller.videoController),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              if (controller.showControls.value)
                _ControlsOverlay(
                  title: title,
                  showHeader: showOverlayHeader,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final String title;
  final bool showHeader;

  _ControlsOverlay({required this.title, required this.showHeader});

  final MoviePlayerController controller = Get.find<MoviePlayerController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.72),
            Colors.transparent,
            Colors.black.withOpacity(0.82),
          ],
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            if (showHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: text13(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _QualityMenu(),
                  ],
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: controller.rewind,
                  icon: const Icon(
                    Icons.replay_10_rounded,
                    color: AppColors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: controller.togglePlay,
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isPlaying.value
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                IconButton(
                  onPressed: controller.forward,
                  icon: const Icon(
                    Icons.forward_10_rounded,
                    color: AppColors.white,
                    size: 34,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        controller.formatDuration(controller.position.value),
                        style: text10(color: AppColors.white),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2.5,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 5,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),
                          child: Slider(
                            value: controller.position.value.inMilliseconds
                                .clamp(
                                  0,
                                  controller.duration.value.inMilliseconds,
                                )
                                .toDouble(),
                            min: 0,
                            max: controller.duration.value.inMilliseconds <= 0
                                ? 1
                                : controller.duration.value.inMilliseconds
                                      .toDouble(),
                            activeColor: AppColors.accentColor,
                            inactiveColor: AppColors.white.withOpacity(0.28),
                            onChanged: controller.seekTo,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatDuration(controller.duration.value),
                        style: text10(color: AppColors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _SmallAction(
                        icon: controller.isMuted.value
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        onTap: controller.toggleMute,
                      ),
                      _SmallAction(
                        icon: Icons.hd_rounded,
                        onTap: () => _showQualitySheet(context),
                      ),
                      _SmallAction(
                        icon: Icons.screen_rotation_rounded,
                        onTap: controller.toggleFullscreen,
                      ),
                      _SmallAction(
                        icon: controller.isFullscreen.value
                            ? Icons.fullscreen_exit_rounded
                            : Icons.fullscreen_rounded,
                        onTap: controller.toggleFullscreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQualitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quality', style: text18(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...controller.qualityUrls.keys.map(
                (quality) => Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(quality, style: text14()),
                    trailing: controller.selectedQuality.value == quality
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primaryColor,
                          )
                        : null,
                    onTap: () {
                      Get.back();
                      controller.changeQuality(quality);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QualityMenu extends StatelessWidget {
  _QualityMenu();

  final MoviePlayerController controller = Get.find<MoviePlayerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopupMenuButton<String>(
        color: AppColors.surfaceColor,
        initialValue: controller.selectedQuality.value,
        onSelected: controller.changeQuality,
        itemBuilder: (_) => controller.qualityUrls.keys
            .map(
              (quality) => PopupMenuItem(
                value: quality,
                child: Row(
                  children: [
                    Expanded(child: Text(quality, style: text13())),
                    if (controller.selectedQuality.value == quality)
                      const Icon(
                        Icons.check,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                  ],
                ),
              ),
            )
            .toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.44),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white.withOpacity(0.16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hd_rounded, color: AppColors.white, size: 16),
              const SizedBox(width: 5),
              Text(controller.selectedQuality.value, style: text11()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.white, size: 21),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
    );
  }
}
