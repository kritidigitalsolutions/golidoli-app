import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/core/services/app_download_service.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/utils/helpers.dart';
import 'package:golidoli_app/utils/text_style.dart';

class DownloadsScreen extends StatelessWidget {
  DownloadsScreen({super.key});

  final DownloadsController controller = Get.put(DownloadsController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Downloads',
      children: [
        // Category Pills Filter
        Obx(() {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.categories.map((cat) {
                final isSelected = controller.selectedCategory.value == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      cat,
                      style: text12(
                        color: isSelected
                            ? AppColors.black
                            : AppColors.secondaryTextColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => controller.selectCategory(cat),
                    backgroundColor: AppColors.surfaceColor,
                    selectedColor: AppColors.primaryColor,
                    checkmarkColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.borderColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
        const SizedBox(height: 16),

        // Downloads List
        Obx(() {
          final items = controller.filteredDownloads;

          if (items.isEmpty) {
            return _buildEmptyState(controller.selectedCategory.value);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.selectedCategory.value} (${items.length})',
                      style: text14(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    Text(
                      'Available Offline',
                      style: text11(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = items[index];
                  return _DownloadedMediaTile(
                    item: item,
                    onPlay: () => controller.playDownloadedItem(context, item),
                    onDelete: () => _confirmDelete(context, item),
                  );
                },
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.download_for_offline_rounded,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Downloads in $category',
            style: text18(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Download movies, series, micro dramas, or audio stories to watch and listen offline without internet.',
            style: text13(color: AppColors.secondaryTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (category == 'Audio') {
                Get.toNamed(AppRoutes.audioStories);
              } else {
                Get.toNamed(AppRoutes.home);
              }
            },
            icon: const Icon(
              Icons.explore_rounded,
              color: AppColors.black,
              size: 18,
            ),
            label: Text(
              'Explore Content',
              style: text13(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, DownloadedMediaItem item) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete Download?',
                style: text16(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Are you sure you want to delete "${item.title}" from your device storage?',
                style: text13(color: AppColors.secondaryTextColor),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: text13(color: AppColors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.removeDownload(item.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: text13(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadedMediaTile extends StatelessWidget {
  final DownloadedMediaItem item;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const _DownloadedMediaTile({
    required this.item,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = item.durationSeconds ~/ 60;
    final seconds = item.durationSeconds % 60;
    final durationText = item.durationSeconds > 0
        ? '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} mins'
        : '';

    final typeLabel = _getMediaTypeLabel(item.mediaType);
    final typeColor = _getMediaTypeColor(item.mediaType);

    return GestureDetector(
      onTap: onPlay,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderColor.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            // Thumbnail with badge
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 52,
                height: 52,
                child: item.coverImage.isNotEmpty
                    ? Image.network(
                        formatMediaUrl(item.coverImage),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _fallbackPlaceholder(item.mediaType),
                      )
                    : _fallbackPlaceholder(item.mediaType),
              ),
            ),
            const SizedBox(width: 12),

            // Title & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: typeColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          typeLabel,
                          style: appTextStyle(
                            fontSize: 9,
                            color: typeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (item.parentTitle.isNotEmpty)
                        Expanded(
                          child: Text(
                            item.parentTitle,
                            style: text11(color: AppColors.secondaryTextColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: text13(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.offline_pin_rounded,
                        size: 12,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.fileSize.isNotEmpty
                            ? (durationText.isNotEmpty
                                  ? '${item.fileSize} • $durationText'
                                  : item.fileSize)
                            : (durationText.isNotEmpty
                                  ? durationText
                                  : 'Offline'),
                        style: text10(color: AppColors.hintTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Play icon
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                color: AppColors.primaryColor,
                size: 32,
              ),
              onPressed: onPlay,
            ),

            // Delete icon
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.hintTextColor,
                size: 22,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _getMediaTypeLabel(DownloadMediaType type) {
    switch (type) {
      case DownloadMediaType.audio:
        return 'AUDIO';
      case DownloadMediaType.movie:
        return 'MOVIE';
      case DownloadMediaType.webSeries:
        return 'SERIES';
      case DownloadMediaType.microDrama:
        return 'DRAMA';
    }
  }

  Color _getMediaTypeColor(DownloadMediaType type) {
    switch (type) {
      case DownloadMediaType.audio:
        return AppColors.primaryColor;
      case DownloadMediaType.movie:
        return Colors.redAccent;
      case DownloadMediaType.webSeries:
        return Colors.blueAccent;
      case DownloadMediaType.microDrama:
        return Colors.purpleAccent;
    }
  }

  Widget _fallbackPlaceholder(DownloadMediaType type) {
    IconData iconData = Icons.headphones_rounded;
    if (type == DownloadMediaType.movie) iconData = Icons.movie_rounded;
    if (type == DownloadMediaType.webSeries) iconData = Icons.tv_rounded;
    if (type == DownloadMediaType.microDrama)
      iconData = Icons.play_lesson_rounded;

    return Container(
      color: AppColors.cardColor,
      child: Center(
        child: Icon(iconData, color: AppColors.primaryColor, size: 24),
      ),
    );
  }
}
