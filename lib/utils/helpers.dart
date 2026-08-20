import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/utils/text_style.dart';

/// Formats media URLs to ensure relative paths from backend (e.g. /uploads/...)
/// are properly prefixed with AppUrl.baseUrl.
String formatMediaUrl(String? url) {
  if (url == null || url.trim().isEmpty) return '';
  final trimmed = url.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  if (trimmed.startsWith('/')) {
    return '${AppUrl.baseUrl}$trimmed';
  }
  return '${AppUrl.baseUrl}/$trimmed';
}

/// Checks if content is playable.
/// If content is premium and user is unsubscribed, shows a subscription bottom sheet prompt and returns false.
bool checkPlayable(
  BuildContext context, {
  required bool isPremium,
  String? title,
}) {
  if (!isPremium) return true;

  final subController = Get.find<SubscriptionStatusController>();
  if (subController.isPremiumUser.value) {
    return true;
  }

  showPremiumPrompt(context, title: title);
  return false;
}

/// Shows a beautiful premium upgrade prompt bottom sheet.
void showPremiumPrompt(BuildContext context, {String? title}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.borderColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.stars_rounded,
            color: AppColors.primaryColor,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Premium Content',
            style: text18(fontWeight: FontWeight.bold, color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            title != null
                ? '“$title” is a premium title. Subscribe to a Premium Plan to unlock this and all other movies, series, and micro dramas!'
                : 'This content is premium. Subscribe to a Premium Plan to unlock this and all other movies, series, and micro dramas!',
            style: text13(color: AppColors.secondaryTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderColor.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: text14(
                          color: AppColors.secondaryTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.subscription);
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accentColor, Color(0xFFFF5E97)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Subscribe Now',
                        style: text14(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
