import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ── Animation ──────────────────────────────────────────
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    animationController.forward();
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.onboarding);
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

// =========================================
// Onboarding controller
// ==============================================

class OnboardingPage {
  final String title;
  final String titleHighlight;
  final String subtitle;
  final String? imagePath;
  final String? imageUrl;
  final Color accentColor;

  const OnboardingPage({
    required this.title,
    this.titleHighlight = '',
    this.subtitle = '',
    this.imagePath,
    this.imageUrl,
    this.accentColor = const Color(0xFFFF0564),
  });
}

class OnboardingController extends GetxController {
  final AuthDatasource _authDatasource = AuthDatasource();
  final PageController pageController = PageController();

  // ── Observables ─────────────────────────────────────
  final RxInt currentPage = 0.obs;

  // ── Pages data ──────────────────────────────────────
  final RxList<OnboardingPage> pages = <OnboardingPage>[
    const OnboardingPage(
      title: 'Blockbuster Movies',
      titleHighlight: '& Web Series',
      subtitle: 'Enjoy premium entertainment in\ncinematic widescreen format.',
      imagePath: 'assets/auth/onborading1.png',
      accentColor: Color(0xFFFF0564), // AppColors.accentColor
    ),
    const OnboardingPage(
      title: 'Short Vertical',
      titleHighlight: 'Dramas',
      subtitle: 'Binge addictive stories\nanytime, anywhere.',
      imagePath: 'assets/auth/onb2.png',
      accentColor: Color(0xFFFED301), // AppColors.primaryColor
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchIntroScreens();
  }

  Future<void> fetchIntroScreens() async {
    try {
      final response = await _authDatasource.fetchIntroScreens();
      if (response != null &&
          response.data != null &&
          response.data!.isNotEmpty) {
        final List<OnboardingPage> apiPages = response.data!.map((item) {
          return OnboardingPage(
            title: item.title ?? 'Welcome',
            imageUrl: item.image,
            accentColor: (item.order ?? 1) % 2 == 0
                ? const Color(0xFFFED301)
                : const Color(0xFFFF0564),
          );
        }).toList();
        pages.assignAll(apiPages);
      }
    } catch (e) {
      debugPrint("Error fetching intro screens: $e");
    }
  }

  // ── Getters ─────────────────────────────────────────
  bool get isLastPage => currentPage.value >= pages.length - 1;
  int get totalPages => pages.length;

  // ── Methods ─────────────────────────────────────────
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      Get.toNamed(AppRoutes.login);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// ====================================================
// Auth controller like login mobile enter otp
// ==================================================

class AuthController extends GetxController {
  final AuthDatasource authDatasource = AuthDatasource();
  // ── Mobile number ────────────────────────────────────
  final TextEditingController mobileController = TextEditingController();
  final RxString mobileNumber = ''.obs;
  final RxBool isMobileValid = false.obs;
  final RxBool isOtpValid = false.obs;
  final RxString mobileError = ''.obs;
  final RxBool sendOtpStatus = false.obs;
  final TextEditingController otpController = TextEditingController();

  final RxString otp = ''.obs;
  final RxBool verifyOtpStatus = false.obs;
  Future<void> sendOTP() async {
    if (!isMobileValid.value) {
      Get.snackbar(
        'Enter mobile number',
        mobileError.value,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      // Start loading
      sendOtpStatus.value = true;

      final result = await authDatasource.sendOtp(phone: mobileNumber.value);

      // Stop loading
      sendOtpStatus.value = false;

      if (result) {
        Get.snackbar("Success", "OTP sent successfully");

        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: {'mobile': mobileController.text},
        );
      } else {
        Get.snackbar("Error", "Failed to send OTP");
      }
    } catch (e) {
      sendOtpStatus.value = false;

      Get.snackbar("Error", e.toString());
    }
  }

  // ── OTP ──────────────────────────────────────────────
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());
  final RxString otpValue = ''.obs;
  final RxBool isOtpComplete = false.obs;
  final RxString otpError = ''.obs;

  // ── Timer ────────────────────────────────────────────
  final RxInt timerSeconds = 45.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;

  // ── Loading ──────────────────────────────────────────
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    mobileController.addListener(() {
      final text = mobileController.text;
      mobileNumber.value = text;

      if (text.isEmpty) {
        mobileError.value = '';
        isMobileValid.value = false;
      } else {
        final regExp = RegExp(r'^[6-9]\d{9}$');
        if (!regExp.hasMatch(text)) {
          if (text.length < 10) {
            mobileError.value = 'Please enter a 10-digit number';
          } else if (!RegExp(r'^[6-9]').hasMatch(text)) {
            mobileError.value =
                'Indian mobile numbers must start with 6, 7, 8, or 9';
          } else {
            mobileError.value = 'Invalid Indian mobile number';
          }
          isMobileValid.value = false;
        } else {
          mobileError.value = '';
          isMobileValid.value = true;
        }
      }
    });
  }

  // ── Mobile screen ────────────────────────────────────
  void sendOtp() async {
    if (!isMobileValid.value) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulated API call
    isLoading.value = false;
    Get.toNamed(
      AppRoutes.verifyOtp,
      arguments: {'mobile': mobileController.text},
    );
    _startTimer();
  }

  // ── OTP screen ───────────────────────────────────────
  void onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
    _updateOtpValue();
  }

  void _updateOtpValue() {
    final otp = otpControllers.map((c) => c.text).join();
    otpValue.value = otp;
    isOtpComplete.value = otp.length == 4;

    if (isOtpComplete.value) {
      _verifyOtp();
    }
  }

  void _verifyOtp() async {
    isLoading.value = true;
    otpError.value = '';
    await Future.delayed(const Duration(seconds: 1)); // Simulated API call
    isLoading.value = false;

    if (otpValue.value == '1234') {
      _timer?.cancel();
      Get.offNamed(AppRoutes.verified);
    } else {
      otpError.value = 'Incorrect OTP. Try entering 1234.';
      isOtpComplete.value = false;
      for (var c in otpControllers) {
        c.clear();
      }
      otpFocusNodes[0].requestFocus();
    }
  }

  void resendOtp() {
    if (!canResend.value) return;
    for (var c in otpControllers) {
      c.clear();
    }
    otpValue.value = '';
    isOtpComplete.value = false;
    otpError.value = '';
    _startTimer();
    // TODO: actual resend API call
  }

  void _startTimer() {
    timerSeconds.value = 45;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
  }

  String get formattedTimer {
    final m = timerSeconds.value ~/ 60;
    final s = timerSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get maskedMobile {
    final args = Get.arguments as Map<String, dynamic>?;
    return args?['mobile'] ?? mobileController.text;
  }

  // ── Verified screen ──────────────────────────────────
  void continueToHome() {
    Get.toNamed(AppRoutes.createAccount);
  }

  @override
  void onClose() {
    mobileController.dispose();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.onClose();
  }
}

// ===============================================================
// Register controller
// =====================================================================

// ── Interest model ────────────────────────────────────
