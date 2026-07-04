import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/auth/models/request/user_payload.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';

class UpdateProfileController extends GetxController {
  final AuthDatasource _datasource = AuthDatasource();

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Loading
  final isLoading = false.obs;

  // Selected Interests
  final RxList<String> selectedInterests = <String>[].obs;

  // Profile Image URL (from server)
  final profileImage = "".obs;

  // Locally picked image, shown optimistically while it uploads
  final Rxn<File> localImageFile = Rxn<File>();

  // Current User
  final Rxn<UserModel> user = Rxn<UserModel>();

  /// Fill controllers from existing user
  void setUser(UserModel userData) {
    user.value = userData;

    nameController.text = userData.name;
    emailController.text = userData.email;
    phoneController.text = userData.phone;

    profileImage.value = userData.profileImage;

    selectedInterests.assignAll(userData.interests);
  }

  /// Toggle Interest
  void toggleInterest(String interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else {
      selectedInterests.add(interest);
    }
  }

  void setLocalImage(File file) {
    localImageFile.value = file;
  }

  /// Update Profile
  /// Update Profile
  Future<bool> updateProfile() async {
    try {
      isLoading.value = true;

      final original = user.value;

      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();

      // Only send an image if the user actually picked a new one.
      final newImagePath = localImageFile.value?.path;

      final interestsChanged =
          original == null ||
          !_listEquals(selectedInterests.toList(), original.interests);

      final payload = UserPayload(
        name: (original == null || name != original.name) ? name : null,
        email: (original == null || email != original.email) ? email : null,
        phone: (original == null || phone != original.phone) ? phone : null,
        interests: interestsChanged ? selectedInterests.toList() : null,
        profileImage: newImagePath, // null if no new file was picked
      );

      final result = await _datasource.updateProfile(userPayload: payload);

      if (result != null) {
        user.value = result;
        Get.snackbar("Success", "Profile updated successfully");
        return true;
      }

      Get.snackbar("Error", "Failed to update profile");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final sa = a.toSet();
    final sb = b.toSet();
    return sa.length == sb.length && sa.containsAll(sb);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
