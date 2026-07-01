import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class DownloadsScreen extends StatelessWidget {
  DownloadsScreen({super.key});

  final DownloadsController controller = Get.put(DownloadsController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Downloads',

      children: [
        Obx(
          () => Column(
            children: List.generate(controller.downloads.length, (index) {
              final item = controller.downloads[index];
              return _MediaTile(
                title: item['title'] ?? '',
                subtitle: item['subtitle'] ?? '',
                trailing: IconButton(
                  onPressed: () => controller.removeDownload(index),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.accentColor,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _MediaTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _MediaTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSurfaceTile(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [AppColors.accentColor, Color(0xFF12002D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.movie_filter_rounded,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text14(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: text12(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
