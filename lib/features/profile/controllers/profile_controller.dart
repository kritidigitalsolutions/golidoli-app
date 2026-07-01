import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:image_picker/image_picker.dart';

// =================================────────────────────────────────────────────
// 1. Profile Controller
// =================================────────────────────────────────────────────
class ProfileController extends GetxController {
  final RxString selectedLanguage = 'English'.obs;

  final Map<String, dynamic> user = {
    'name': 'Aradhya Jain',
    'isPremium': true,
    'avatar': 'https://picsum.photos/seed/aradhya/200/200',
    'continueTitle': "Billionaire's Obsession",
    'continueEpisode': 'S1 E05',
    'continueProgress': 0.60,
    'continueImage': 'https://picsum.photos/seed/billionaire/400/200',
  };

  final List<Map<String, dynamic>> menuItems = [
    {'icon': 'edit', 'label': 'Edit Profile'},
    {'icon': 'subscription', 'label': 'Subscription'},
    {'icon': 'language', 'label': 'Language', 'trailing': 'English'},
    {'icon': 'download', 'label': 'Downloads'},
    {'icon': 'content', 'label': 'Content Preference'},
    {'icon': 'settings', 'label': 'Notifications Settings'},
    {'icon': 'privacy', 'label': 'Privacy Policy'},
    {'icon': 'terms', 'label': 'Terms & Conditions'},
  ];

  void onMenuTap(String label) {
    final routes = {
      'Edit Profile': AppRoutes.editProfile,
      'Subscription': AppRoutes.subscription,
      'Language': AppRoutes.language,
      'Downloads': AppRoutes.downloads,
      'Content Preference': AppRoutes.contentPreference,
      'Notifications Settings': AppRoutes.notificationSettings,
      'Privacy Policy': AppRoutes.privacyPolicy,
      'Terms & Conditions': AppRoutes.termsConditions,
    };

    final route = routes[label];
    if (route != null) {
      Get.toNamed(route);
    }
  }

  void onLogOut() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: AppColors.accentColor,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                'Log Out',
                style: text18(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to log out from GoliDoli?',
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
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.borderColor.withOpacity(0.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: text13(
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
                        Get.offAllNamed(AppRoutes.login);
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accentColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Log Out',
                            style: text13(
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
            ],
          ),
        ),
      ),
    );
  }
}

// =================================────────────────────────────────────────────
// 2. Content Preference Controller
// =================================────────────────────────────────────────────
class ContentPreferenceController extends GetxController {
  final genres = const ['Romance', 'Thriller', 'Drama', 'Action', 'Comedy'];
  final contentTypes = const ['Movies', 'Web Series', 'Micro Dramas'];
  final RxSet<String> selectedPreferences = <String>{
    'Romance',
    'Drama',
    'Movies',
  }.obs;

  void togglePreference(String value) {
    if (selectedPreferences.contains(value)) {
      selectedPreferences.remove(value);
    } else {
      selectedPreferences.add(value);
    }
  }

  void savePreference() {
    Get.snackbar('Preferences Updated', 'Your content choices are saved.');
  }
}

// =================================────────────────────────────────────────────
// 3. Downloads Controller
// =================================────────────────────────────────────────────
class DownloadsController extends GetxController {
  final RxList<Map<String, String>> downloads = <Map<String, String>>[
    {'title': 'Forbidden Love', 'subtitle': 'S1 E03 | 156 MB'},
    {'title': 'City Chase', 'subtitle': 'S1 E08 | 212 MB'},
    {'title': 'Toxic Love', 'subtitle': 'Movie | 820 MB'},
  ].obs;

  void removeDownload(int index) {
    downloads.removeAt(index);
  }
}

// =================================────────────────────────────────────────────
// 4. Edit Profile Controller
// =================================────────────────────────────────────────────
class EditProfileController extends GetxController {
  final nameController = TextEditingController(text: 'Aradhya Jain');
  final mobileController = TextEditingController(text: '+91 98765 43210');
  final emailController = TextEditingController(text: 'aradhya@golidoli.com');

  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isSaving = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  void showImagePicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.white),
                title: Text(
                  "Camera",
                  style: text14(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.white,
                ),
                title: Text(
                  "Gallery",
                  style: text14(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveProfile() async {
    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isSaving.value = false;

    Get.snackbar('Profile Updated', 'Your changes have been saved.');
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.onClose();
  }
}

// =================================────────────────────────────────────────────
// 5. Language Controller
// =================================────────────────────────────────────────────
class LanguageController extends GetxController {
  final languages = const ['English', 'Hindi', 'Tamil', 'Telugu', 'Bengali'];
  final RxString selectedLanguage = 'English'.obs;

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }
}

// =================================────────────────────────────────────────────
// 6. Notification Settings Controller
// =================================────────────────────────────────────────────
class NotificationSettingsController extends GetxController {
  final RxBool newEpisodes = true.obs;
  final RxBool newMovies = true.obs;
  final RxBool recommendations = true.obs;
  final RxBool downloads = true.obs;
  final RxBool continueWatchingReminder = false.obs;
  final RxBool subscriptionAlerts = true.obs;
  final RxBool promotionalOffers = true.obs;

  void saveChanges() {
    Get.snackbar(
      'Saved',
      'Notification settings updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// =================================────────────────────────────────────────────
// 7. Notifications Controller
// =================================────────────────────────────────────────────
class NotificationsController extends GetxController {
  final RxList<Map<String, String>> notifications = <Map<String, String>>[
    {
      'title': 'New episode released',
      'subtitle': 'Billionaire Series S1 E06 is ready to watch.',
      'time': '2 min ago',
    },
    {
      'title': 'Premium offer',
      'subtitle': 'Get yearly access with extra savings today.',
      'time': '1 hour ago',
    },
    {
      'title': 'Download complete',
      'subtitle': 'Forbidden Love is available offline.',
      'time': 'Yesterday',
    },
  ].obs;

  void clearAll() {
    notifications.clear();
  }
}

// =================================────────────────────────────────────────────
// 8. Privacy Controller
// =================================────────────────────────────────────────────
class PrivacyController extends GetxController {
  final sections = const [
    {
      'title': 'Data We Collect',
      'body': 'We use profile, watch history, preferences, and device data to improve your streaming experience.',
    },
    {
      'title': 'How We Use Data',
      'body': 'Your data helps personalize recommendations, manage subscriptions, improve safety, and support downloads.',
    },
    {
      'title': 'Your Choices',
      'body': 'You can update profile details, content preferences, notification choices, and account settings anytime.',
    },
  ];
}

// =================================────────────────────────────────────────────
// 9. Subscription Controller
// =================================────────────────────────────────────────────
class SubscriptionController extends GetxController {
  final RxBool isYearly = false.obs;

  void selectMonthly() => isYearly.value = false;
  void selectYearly() => isYearly.value = true;

  void onContinueToPay() {
    Get.toNamed(AppRoutes.premiumWelcome);
  }

  String get premiumPrice => isYearly.value ? '₹799' : '₹99';
  String get premiumPeriod => isYearly.value ? '/year' : '/month';
}

// =================================────────────────────────────────────────────
// 10. Terms Controller
// =================================────────────────────────────────────────────
class TermsController extends GetxController {
  final sections = const [
    {
      'title': 'Using GoliDoli',
      'body': 'Use the app only for personal entertainment and follow all applicable laws and platform rules.',
    },
    {
      'title': 'Subscriptions',
      'body': 'Premium benefits, billing cycles, offers, and cancellation terms may vary by plan and region.',
    },
    {
      'title': 'Content Access',
      'body': 'Movies, web series, micro dramas, downloads, and quality settings can change based on rights and availability.',
    },
  ];
}

// =================================────────────────────────────────────────────
// 11. Watchlist Controller
// =================================────────────────────────────────────────────
class WatchlistController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  final List<String> tabs = ['Movies', 'Series', 'Micro Dramas'];

  // --- Movies ---
  final List<Map<String, String>> movies = List.generate(
    9,
    (i) => {
      'title': i % 3 == 0
          ? 'Me Before You'
          : i % 3 == 1
              ? 'Squid Game'
              : 'Connect',
      'image': 'https://picsum.photos/seed/wm${i + 1}/200/300',
    },
  );

  // --- Series ---
  final List<Map<String, String>> series = List.generate(
    9,
    (i) => {
      'title': i % 3 == 0
          ? 'Me Before You'
          : i % 3 == 1
              ? 'Squid Game'
              : 'Connect',
      'image': 'https://picsum.photos/seed/ws${i + 1}/200/300',
    },
  );

  // --- Micro Dramas ---
  final List<Map<String, String>> microDramas = List.generate(
    9,
    (i) => {
      'title': i % 3 == 0
          ? 'My Racer Stepbrother'
          : i % 3 == 1
              ? 'The True Heiress'
              : 'Connect',
      'image': 'https://picsum.photos/seed/wd${i + 1}/200/300',
    },
  );

  List<Map<String, String>> get currentList {
    switch (selectedTabIndex.value) {
      case 0:
        return movies;
      case 1:
        return series;
      default:
        return microDramas;
    }
  }

  void selectTab(int index) => selectedTabIndex.value = index;
}
