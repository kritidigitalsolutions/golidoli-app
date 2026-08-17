import 'dart:io';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/auth/models/request/user_payload.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';

class EditProfileController extends GetxController {
  // final UpdateProfileUsecase _updateProfileUsecase;

  // EditProfileController({required UpdateProfileUsecase updateProfileUsecase})
  //     : _updateProfileUsecase = updateProfileUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final Rx<UserModel?> user = Rx(null);
  final Rx<File?> localImageFile = Rx(null);
  final status = Status.init.obs;
  final RxString errorMessage = ''.obs;

  // ── Actions ───────────────────────────────────────────────────────────────
  void initialize(UserModel userModel) {
    user.value = userModel;
    localImageFile.value = null;
    status.value = Status.init;
    errorMessage.value = '';
  }

  void changeLocalImage(File imageFile) {
    localImageFile.value = imageFile;
  }

  final AuthDatasource _api = AuthDatasource();

  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final original = user.value;
    if (original == null) return;

    status.value = Status.loading;
    errorMessage.value = '';

    try {
      final trimmedName = name.trim();
      final trimmedEmail = email.trim();
      final trimmedPhone = phone.trim();
      final newImagePath = localImageFile.value?.path;

      final payload = UserPayload(
        name: trimmedName != original.name ? trimmedName : null,
        email: trimmedEmail != original.email ? trimmedEmail : null,
        phone: trimmedPhone != original.phone ? trimmedPhone : null,
        interests: null,
        profileImage: newImagePath,
      );

      final result = await _api.updateProfile(userPayload: payload);

      if (result != null) {
        user.value = result;
        status.value = Status.success;
      } else {
        status.value = Status.error;
        errorMessage.value = 'Failed to update profile';
      }
    } catch (e) {
      status.value = Status.error;
      errorMessage.value = e.toString();
    }
  }
}
