import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/auth/controllers/auth_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0520),
                  Color(0xFF0D0614),
                  Color(0xFF0A0A18),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textColor,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'Verify Your',
                          style: text24(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Mobile Number',
                          style: text24(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Subtitle
                        Text(
                          "We've sent a 4-digit verification code to",
                          style: text13(color: AppColors.secondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),

                        // Mobile number row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '+91 ${controller.maskedMobile}',
                              style: text14(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 16,
                                color: AppColors.accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),

                        // OTP boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (i) => _OtpBox(
                              index: i,
                              controller: controller.otpControllers[i],
                              focusNode: controller.otpFocusNodes[i],
                              onChanged: (v) => controller.onOtpChanged(v, i),
                            ),
                          ),
                        ),
                        Obx(() {
                          if (controller.otpError.value.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                controller.otpError.value,
                                style: text12(color: AppColors.errorColor),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        const SizedBox(height: 28),

                        // Resend timer
                        Obx(
                          () => controller.canResend.value
                              ? GestureDetector(
                                  onTap: controller.resendOtp,
                                  child: Text(
                                    'Resend OTP',
                                    style: text14(
                                      color: AppColors.accentColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : RichText(
                                  text: TextSpan(
                                    text: 'Resend OTP in ',
                                    style: text13(
                                      color: AppColors.secondaryTextColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller.formattedTimer,
                                        style: text13(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                _SecurityBadge(),
              ],
            ),
          ),

          // Loading overlay
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Single OTP input box ─────────────────────────────
class _OtpBox extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: AppColors.white,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: text24(fontWeight: FontWeight.w700, color: AppColors.textColor),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ─── Security info badge ──────────────────────────────
class _SecurityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accentColor.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.security_rounded,
            color: AppColors.accentColor,
            size: 26,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Your data is 100% secure\nand encrypted',
          style: text12(color: AppColors.hintTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
