import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class AuthControllers extends GetxController {
  final AuthDatasource authDatasource = AuthDatasource();

  //══════════════════════════════════════
  // Mobile
  //══════════════════════════════════════

  final TextEditingController mobileController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final RxList<String> selectedInterests = <String>[].obs;

  // Loading
  final RxBool isCompleteProfileLoading = false.obs;
  // Interests
  final RxString mobileNumber = ''.obs;
  final RxBool isMobileValid = false.obs;
  final RxString mobileError = ''.obs;

  final RxBool sendOtpStatus = false.obs;

  //══════════════════════════════════════
  // OTP
  //══════════════════════════════════════

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  final RxString otp = ''.obs;
  final RxBool isOtpValid = false.obs;
  final RxString otpError = ''.obs;

  final RxBool verifyOtpStatus = false.obs;

  //══════════════════════════════════════
  // Timer
  //══════════════════════════════════════

  Timer? _timer;

  final RxInt secondsRemaining = 30.obs;
  final RxBool canResend = false.obs;

  String get formattedTimer {
    final min = (secondsRemaining.value ~/ 60).toString().padLeft(2, '0');

    final sec = (secondsRemaining.value % 60).toString().padLeft(2, '0');

    return "$min:$sec";
  }

  //══════════════════════════════════════
  // Init
  //══════════════════════════════════════

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['mobile'] != null) {
      mobileNumber.value = Get.arguments['mobile'];
      mobileController.text = mobileNumber.value;
      startTimer();
    }
  }

  //══════════════════════════════════════
  // Mobile Validation
  //══════════════════════════════════════

  void validateMobile(String value) {
    mobileNumber.value = value.trim();

    if (value.isEmpty) {
      mobileError.value = "Mobile number is required";
      isMobileValid.value = false;
    } else if (value.length != 10) {
      mobileError.value = "Enter valid mobile number";
      isMobileValid.value = false;
    } else {
      mobileError.value = "";
      isMobileValid.value = true;
    }
  }

  //══════════════════════════════════════
  // Send OTP
  //══════════════════════════════════════

  Future<void> sendOTP() async {
    if (!isMobileValid.value) {
      Get.snackbar("Error", mobileError.value, backgroundColor: Colors.red);
      return;
    }

    try {
      sendOtpStatus.value = true;

      final result = await authDatasource.sendOtp(phone: mobileNumber.value);

      sendOtpStatus.value = false;

      if (result) {
        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {"mobile": mobileNumber.value},
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to send OTP",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      sendOtpStatus.value = false;

      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }

  //══════════════════════════════════════
  // OTP
  //══════════════════════════════════════

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      otpFocusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }

    otp.value = otpControllers.map((e) => e.text).join();

    isOtpValid.value = otp.value.length == 4;

    if (!isOtpValid.value) {
      otpError.value = "Enter valid OTP";
    } else {
      otpError.value = "";
      otpFocusNodes[index].unfocus();
      verifyOTP(); // <-- auto-trigger verification
    }
  }
  //══════════════════════════════════════
  // Verify OTP
  //══════════════════════════════════════

  Future<void> verifyOTP() async {
    if (!isOtpValid.value) {
      otpError.value = "Please enter a valid OTP";
      return;
    }

    try {
      verifyOtpStatus.value = true;

      final enteredOtp = otpControllers.map((e) => e.text).join();

      final result = await authDatasource.verifyOtp(
        phone: mobileNumber.value,
        otp: enteredOtp,
      );

      verifyOtpStatus.value = false;

      if (result.success) {
        if (!result.profileComplete) {
          Get.offAllNamed(
            AppRoutes.createAccount,
            arguments: {"mobile": mobileNumber.value},
          );
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        Get.snackbar("Error", "Invalid OTP", backgroundColor: Colors.red);
      }
    } catch (e) {
      verifyOtpStatus.value = false;

      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    }
  }
  //══════════════════════════════════════
  // Timer
  //══════════════════════════════════════

  void startTimer() {
    canResend.value = false;
    secondsRemaining.value = 30;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    final result = await authDatasource.sendOtp(phone: mobileNumber.value);

    if (result) {
      otpControllers.forEach((e) => e.clear());

      otp.value = "";
      isOtpValid.value = false;

      startTimer();

      otpFocusNodes.first.requestFocus();

      Get.snackbar("Success", "OTP sent again", backgroundColor: Colors.green);
    } else {
      Get.snackbar(
        "Error",
        "Failed to resend OTP",
        backgroundColor: Colors.red,
      );
    }
  }

  //══════════════════════════════════════
  // Dispose
  //══════════════════════════════════════

  @override
  void onClose() {
    mobileController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }

    for (final f in otpFocusNodes) {
      f.dispose();
    }

    _timer?.cancel();

    super.onClose();
  }
}
