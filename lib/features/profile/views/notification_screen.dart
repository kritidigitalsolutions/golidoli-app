import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Notifications',
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: controller.clearAll,
            child: Text(
              'Clear All',
              style: text12(color: AppColors.accentColor),
            ),
          ),
        ),
        Obx(
          () => controller.notifications.isEmpty
              ? _EmptyState()
              : Column(
                  children: List.generate(controller.notifications.length, (
                    index,
                  ) {
                    final item = controller.notifications[index];

                    return Dismissible(
                      key: ValueKey("${item['title']}_${item['time']}_$index"),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      onDismissed: (_) {
                        controller.notifications.removeAt(index);

                        Get.snackbar(
                          "Notification Removed",
                          "Notification dismissed",
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: ProfileSurfaceTile(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.notifications_active_outlined,
                              color: AppColors.primaryColor,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: text14(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['subtitle'] ?? '',
                                    style: text12(
                                      color: AppColors.secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item['time'] ?? '',
                                    style: text10(
                                      color: AppColors.hintTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileSurfaceTile(
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            color: AppColors.hintTextColor,
            size: 38,
          ),
          const SizedBox(height: 10),
          Text(
            'No notifications yet',
            style: text14(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
