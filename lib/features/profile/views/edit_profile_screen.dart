import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/profile/controllers/update_profile_controller.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/profile/controllers/fetch_profile_controller.dart';
import 'package:golidoli_app/shared/widgets/custom_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:golidoli_app/constants/app_colors.dart';

import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UpdateProfileController controller = Get.put(UpdateProfileController());
  final FetchProfileController fetchController = Get.put(
    FetchProfileController(),
  );

  Worker? _userWorker;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();

    // Seed the form once from whatever user data is already available.
    final existingUser = fetchController.user.value;
    if (existingUser != null) {
      controller.setUser(existingUser);
      _seeded = true;
    } else {
      // Not loaded yet — wait for the first successful fetch, seed once,
      // then stop listening so later refreshes don't clobber user edits.
      _userWorker = ever<UserModel?>(fetchController.user, (userData) {
        if (!_seeded && userData != null) {
          controller.setUser(userData);
          _seeded = true;
          _userWorker?.dispose();
          _userWorker = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _userWorker?.dispose();
    // Drop these controllers when leaving the screen so a future visit
    // starts clean instead of reusing stale state / re-registering.
    Get.delete<UpdateProfileController>();
    Get.delete<FetchProfileController>();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked == null) return;

    // Just preview it locally — it's uploaded together with the rest of
    // the form fields when the user taps "Save Changes".
    controller.setLocalImage(File(picked.path));
  }

  Future<void> _onSave() async {
    final success = await controller.updateProfile();

    if (success) {
      // Keep FetchProfileController in sync so any other screen reading
      // the profile (e.g. the one we're about to pop back to) shows the
      // freshly saved data instead of the stale pre-edit version.
      if (controller.user.value != null) {
        fetchController.updateUser(controller.user.value!);
      }
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Edit Profile',
      children: [
        Obx(() {
          // Only block the whole form on the very first load, when there's
          // no cached user yet to show.
          if (fetchController.isLoading.value &&
              fetchController.user.value == null) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (fetchController.error.value.isNotEmpty &&
              fetchController.user.value == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text(
                    fetchController.error.value,
                    style: text14(color: AppColors.secondaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: fetchController.refreshProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Center(
                child: Obx(
                  () => CustomImagePicker(
                    imageFile: controller.localImageFile.value,
                    imageUrl: controller.profileImage.value,
                    onTap: _pickAndUploadImage,
                    radius: 42,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              _InputField(
                label: 'Full Name',
                controller: controller.nameController,
              ),
              _InputField(
                label: 'Mobile Number',
                controller: controller.phoneController,
              ),
              _InputField(
                label: 'Email Address',
                controller: controller.emailController,
              ),
              const SizedBox(height: 18),
              Obx(
                () => ProfilePrimaryButton(
                  title: controller.isLoading.value
                      ? 'Saving...'
                      : 'Save Changes',
                  onTap: controller.isLoading.value ? () {} : _onSave,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _InputField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text12(color: AppColors.secondaryTextColor)),
          const SizedBox(height: 7),
          TextField(
            controller: controller,
            style: text14(),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.borderColor.withOpacity(0.6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.accentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
