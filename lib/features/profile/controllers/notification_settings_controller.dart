import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/profile/repositories/notification_repository.dart';

class NotificationSettingsController extends GetxController {
  final NotificationRepository _repository = NotificationRepository();

  final RxBool newEpisodes = true.obs;
  final RxBool newMovies = true.obs;
  final RxBool recommendations = true.obs;
  final RxBool downloads = true.obs;
  final RxBool continueWatchingReminder = false.obs;
  final RxBool subscriptionAlerts = true.obs;
  final RxBool promotionalOffers = true.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      final response = await _repository.getNotificationSettings();
      if (response != null && response['success'] == true) {
        final settings = response['notificationSettings'] ?? response['settings'] ?? response['data'] ?? {};
        newEpisodes.value = settings['newEpisodes'] ?? true;
        newMovies.value = settings['newMovies'] ?? true;
        recommendations.value = settings['recommendations'] ?? true;
        downloads.value = settings['downloads'] ?? true;
        continueWatchingReminder.value = settings['continueWatching'] ?? settings['continueWatchingReminder'] ?? false;
        subscriptionAlerts.value = settings['subscriptionAlerts'] ?? true;
        promotionalOffers.value = settings['promotionalOffers'] ?? true;
      }
    } catch (e) {
      debugPrint("Error fetching notification settings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;
      final response = await _repository.updateNotificationSettings({
        "newEpisodes": newEpisodes.value,
        "newMovies": newMovies.value,
        "recommendations": recommendations.value,
        "downloads": downloads.value,
        "continueWatching": continueWatchingReminder.value,
        "subscriptionAlerts": subscriptionAlerts.value,
        "promotionalOffers": promotionalOffers.value,
      });

      if (response != null && response['success'] == true) {
        Get.snackbar(
          'Saved',
          'Notification settings updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update notification settings.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error saving notification settings: $e");
      Get.snackbar(
        'Error',
        'An error occurred while saving: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
