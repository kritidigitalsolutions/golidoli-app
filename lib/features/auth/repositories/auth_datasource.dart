import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/auth/models/request/user_payload.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class AuthDatasource {
  Future<bool> sendOtp({required String phone}) async {
    final url = Uri.parse(AppUrl.sendOtp);
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: convert.jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint(response.body);
      return true;
    }
    debugPrint('Failed to send OTP: ${response.statusCode}');
    return false;
  }

  Future<VerifyOtpResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final url = Uri.parse(AppUrl.verifyOtp);

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({"phone": phone, "otp": otp}),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);

        final token = data["token"] ?? "";
        await StorageService.saveToken(token);

        final bool profileComplete = data["user"]["profileComplete"] ?? false;

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
      final url = Uri.parse(AppUrl.completeProfile);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          // if (token != null) "Authorization": "Bearer $token",
        },
        body: convert.jsonEncode(userPayload.toJson()),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);
        final String token = data["token"];
        await StorageService.saveToken(token);
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
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint("Token is null");
        return null;
      }

      final url = Uri.parse(AppUrl.fetchProfile);

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);

        return UserModel.fromJson(data["user"]);
      }

      return null;
    } catch (e) {
      debugPrint("Fetch Profile Error: $e");
      return null;
    }
  }

  Future<UserModel?> updateProfile({required UserPayload userPayload}) async {
    try {
      final url = Uri.parse(AppUrl.updateProfile);

      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        debugPrint("Token not found");
        return null;
      }

      // Create multipart request
      final request = http.MultipartRequest("PATCH", url);

      // Add Authorization header
      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      // Get payload data
      final data = userPayload.toJson();
      debugPrint("📦 Payload Data: $data");

      // Add all fields except profileImage
      data.forEach((key, value) {
        if (key == "profileImage" || value == null) return;

        if (value is List) {
          // ✅ Send interests as JSON string
          request.fields[key] = convert.jsonEncode(value);
          debugPrint("📝 Field: $key = ${convert.jsonEncode(value)}");
        } else {
          request.fields[key] = value.toString();
          debugPrint("📝 Field: $key = ${value.toString()}");
        }
      });

      // Handle profileImage if it's a file path
      final profileImage = userPayload.profileImage;
      if (profileImage != null && profileImage.isNotEmpty) {
        // Check if it's a local file path (not a URL)
        final isLocalFile = !profileImage.startsWith("http") &&
            !profileImage.startsWith("https");

        if (isLocalFile) {
          final file = File(profileImage);
          if (await file.exists()) {
            debugPrint("🖼️ Attaching file: $profileImage");
            request.files.add(
              await http.MultipartFile.fromPath(
                "profileImage",
                profileImage,
              ),
            );
          } else {
            debugPrint("⚠️ File not found: $profileImage");
            // If file doesn't exist, send as text field
            request.fields["profileImage"] = profileImage;
          }
        } else {
          // Already a URL, send as text field
          request.fields["profileImage"] = profileImage;
          debugPrint("📝 profileImage URL: $profileImage");
        }
      }

      debugPrint("🚀 Sending PATCH request to: ${AppUrl.updateProfile}");
      debugPrint("📋 Request Fields: ${request.fields}");
      debugPrint("📎 Request Files: ${request.files.length}");

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📊 Status Code: ${response.statusCode}");
      debugPrint("📄 Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = convert.jsonDecode(response.body);
        if (responseData.containsKey("user")) {
          return UserModel.fromJson(responseData["user"]);
        }
        return null;
      }

      debugPrint("❌ Update failed with status: ${response.statusCode}");
      return null;
    } catch (e, stackTrace) {
      debugPrint("❌ Update Profile Error: $e");
      debugPrint("📍 StackTrace: $stackTrace");
      return null;
    }
  }
}
// Inside AuthDatasource

/// Sends profile fields as multipart form fields, and — if
/// `userPayload.profileImage` points to a local file path rather than an
/// already-hosted URL — attaches it as a file, mirroring the pattern used
/// in `registerUser`.
Future<UserModel?> updateProfile({required UserPayload userPayload}) async {
  try {
    final url = Uri.parse(AppUrl.updateProfile);

    final token = await StorageService.getToken();

    if (token == null || token.isEmpty) {
      debugPrint("Token not found");
      return null;
    }

    final request = http.MultipartRequest("PATCH", url);

    request.headers.addAll({"Authorization": "Bearer $token"});

    final data = userPayload.toJson();

    // Text fields (everything except profileImage, which needs special
    // handling depending on whether it's a local path or a hosted URL).
    data.forEach((key, value) {
      if (key == "profileImage" || value == null) return;

      if (value is List) {
        request.fields[key] = convert.jsonEncode(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    final profileImage = userPayload.profileImage;

    if (profileImage != null && profileImage.isNotEmpty) {
      final isLocalFile = !profileImage.startsWith("http");

      if (isLocalFile) {
        debugPrint("🖼 Upload Profile Image: $profileImage");
        request.files.add(
          await http.MultipartFile.fromPath("profileImage", profileImage),
        );
      } else {
        // Already a hosted URL — just pass it through as a plain field.
        request.fields["profileImage"] = profileImage;
      }
    }

    debugPrint("🚀 Sending Update Profile Request: ${AppUrl.updateProfile}");

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return UserModel.fromJson(data["user"]);
    }

    return null;
  } catch (e, stackTrace) {
    debugPrint("❌ Update Profile Error: $e");
    debugPrint("📍 StackTrace: $stackTrace");
    return null;
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
