import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/data/network/network_api_service.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/auth/models/request/user_payload.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';

class AuthDatasource {
  final NetworkApiService _apiService = NetworkApiService();

  Future<bool> sendOtp({required String phone}) async {
    try {
      final response = await _apiService.postApi(AppUrl.sendOtp, {
        'phone': phone,
      });
      if (response != null) {
        debugPrint("Send OTP Response: $response");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to send OTP: $e');
      return false;
    }
  }

  Future<VerifyOtpResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _apiService.postApi(AppUrl.verifyOtp, {
        "phone": phone,
        "otp": otp,
      });

      if (response != null) {
        final token = response["token"] ?? "";
        await StorageService.saveToken(token);
        _apiService.setToken(token);

        final bool profileComplete =
            response["user"]["profileComplete"] ?? false;
        return VerifyOtpResult(success: true, profileComplete: profileComplete);
      }

      return VerifyOtpResult.failure();
    } catch (e) {
      debugPrint("Verify OTP Error: $e");
      return VerifyOtpResult.failure();
    }
  }

  Future<bool> completeProfile({required UserPayload userPayload}) async {
    try {
      final response = await _apiService.postApi(
        AppUrl.completeProfile,
        userPayload.toJson(),
      );

      if (response != null) {
        final String token = response["token"];
        await StorageService.saveToken(token);
        _apiService.setToken(token);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Complete Profile Error: $e");
      return false;
    }
  }

  Future<UserModel?> fetchProfile() async {
    try {
      final response = await _apiService.getApi(AppUrl.fetchProfile);
      if (response != null && response["user"] != null) {
        return UserModel.fromJson(response["user"]);
      }
      return null;
    } catch (e) {
      debugPrint("Fetch Profile Error: $e");
      return null;
    }
  }

  Future<UserModel?> updateProfile({required UserPayload userPayload}) async {
    try {
      final formDataMap = <String, dynamic>{};
      final data = userPayload.toJson();

      data.forEach((key, value) {
        if (key == "profileImage" || value == null) return;
        if (value is List) {
          formDataMap[key] = convert.jsonEncode(value);
        } else {
          formDataMap[key] = value.toString();
        }
      });

      final profileImage = userPayload.profileImage;
      if (profileImage != null && profileImage.isNotEmpty) {
        final isLocalFile =
            !profileImage.startsWith("http") &&
            !profileImage.startsWith("https");

        if (isLocalFile) {
          final file = File(profileImage);
          if (await file.exists()) {
            debugPrint("🖼️ Attaching file: $profileImage");
            formDataMap["profileImage"] = await dio.MultipartFile.fromFile(
              profileImage,
              filename: profileImage.split('/').last,
            );
          } else {
            formDataMap["profileImage"] = profileImage;
          }
        } else {
          formDataMap["profileImage"] = profileImage;
        }
      }

      final formData = dio.FormData.fromMap(formDataMap);
      final response = await _apiService.pacthApi(
        AppUrl.updateProfile,
        formData,
      );

      if (response != null && response.containsKey("user")) {
        return UserModel.fromJson(response["user"]);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Update Profile Error: $e");
      return null;
    }
  }
}

class VerifyOtpResult {
  final bool success;
  final bool profileComplete;

  VerifyOtpResult({required this.success, required this.profileComplete});

  factory VerifyOtpResult.failure() {
    return VerifyOtpResult(success: false, profileComplete: false);
  }
}
