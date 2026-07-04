import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';

class FetchProfileController extends GetxController {
  final AuthDatasource _datasource = AuthDatasource();

  /// Loading State
  final RxBool isLoading = false.obs;

  /// User Data
  final Rxn<UserModel> user = Rxn<UserModel>();

  /// Error Message
  final RxString error = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      error.value = "";

      final result = await _datasource.fetchProfile();

      if (result != null) {
        user.value = result;
      } else {
        error.value = "Unable to fetch profile.";
      }
    } catch (e) {
      debugPrint("Profile Controller Error: $e");
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh Profile
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  /// Update locally using copyWith()
  void updateUser(UserModel updatedUser) {
    user.value = updatedUser;
  }

  /// Example
  void updateName(String name) {
    if (user.value == null) return;

    user.value = user.value!.copyWith(name: name);
  }

  void updateProfileImage(String image) {
    if (user.value == null) return;

    user.value = user.value!.copyWith(profileImage: image);
  }
}
