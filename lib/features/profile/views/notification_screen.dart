import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/notifications_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:golidoli_app/core/services/firebase_service.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Notifications',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: controller.clearAll,
                child: Text(
                  'Mark All Read',
                  style: text12(color: AppColors.accentColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Delete All',
                    middleText: 'Are you sure you want to delete all notifications?',
                    textConfirm: 'Yes',
                    textCancel: 'No',
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.primaryColor,
                    onConfirm: () {
                      Get.back();
                      controller.deleteAll();
                    },
                  );
                },
                child: Text(
                  'Delete All',
                  style: text12(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: CircularProgressIndicator(color: AppColors.accentColor),
              ),
            );
          }

          if (controller.notifications.isEmpty) {
            return _EmptyState();
          }

          return Column(
            children: List.generate(controller.notifications.length, (index) {
              final item = controller.notifications[index];

              return Dismissible(
                key: ValueKey("${item['id']}_${item['title']}_$index"),
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
                  controller.deleteNotification(index);

                  Get.snackbar(
                    "Notification Removed",
                    "Notification dismissed successfully",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    controller.markRead(index);
                    Get.find<NotificationService>().handleNotificationClick(item);
                  },
                  child: ProfileSurfaceTile(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          (item['isRead'] ?? false)
                              ? Icons.notifications_none_outlined
                              : Icons.notifications_active_outlined,
                          color: (item['isRead'] ?? false)
                              ? AppColors.secondaryTextColor
                              : AppColors.primaryColor,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] ?? '',
                                      style: text14(
                                        fontWeight: (item['isRead'] ?? false)
                                            ? FontWeight.w500
                                            : FontWeight.bold,
                                        color: (item['isRead'] ?? false)
                                            ? AppColors.secondaryTextColor
                                            : AppColors.white,
                                      ),
                                    ),
                                  ),
                                  if (!(item['isRead'] ?? false))
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.accentColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle'] ?? '',
                                style: text12(
                                  color: (item['isRead'] ?? false)
                                      ? AppColors.hintTextColor
                                      : AppColors.secondaryTextColor,
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
                ),
              );
            }),
          );
        }),
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
