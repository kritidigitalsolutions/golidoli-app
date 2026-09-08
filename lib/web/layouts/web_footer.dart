import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/app_images.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  Widget _buildRedLink(String label, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryPink,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = WebResponsive.isMobile(context);
    final horizontalPadding = WebResponsive.contentHorizontalPadding(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          top: BorderSide(
            color: AppColors.borderColor.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 40 : 54,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. App Logo
              Image.asset(
                AppImages.logo,
                height: isMobile ? 44 : 60,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.primaryPink,
                  size: 48,
                ),
              ),
              const SizedBox(height: 14),

              // 2. Brand Title
              const Text(
                'GOLIDOLI OTT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 14),

              // 3. Tagline / Description
              const Text(
                'The ultimate destination for premium entertainment. Watch the latest web series, movies, and originals anytime, anywhere.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13.5,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),

              // 4. Support Email
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  'Email: support@golidoliapp.in',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryPink,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Red Legal / Navigation Links
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: isMobile ? 16 : 28,
                runSpacing: 12,
                children: [
                  _buildRedLink(
                    'Privacy Policy',
                    () => Get.toNamed(AppRoutes.privacyPolicy),
                  ),
                  _buildRedLink(
                    'Terms & Conditions',
                    () => Get.toNamed(AppRoutes.termsConditions),
                  ),
                  _buildRedLink(
                    'Refund Policy',
                    () => Get.toNamed(AppRoutes.refundPolicy),
                  ),
                  _buildRedLink(
                    'Help & Support',
                    () => Get.toNamed(AppRoutes.faq),
                  ),
                ],
              ),
              const SizedBox(height: 38),

              // 6. Copyright Text
              Text(
                '© ${DateTime.now().year} GoliDoli OTT All Rights Reserved',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 12,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 12),

              // 7. Powered By
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                  children: [
                    TextSpan(
                      text: 'POWERED BY ',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'KRITI DIGITAL SOLUTIONS',
                      style: TextStyle(
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 8. Registered Address & Company Info
              const Text(
                'Floor No 12, 1202, Residences Tanaji Nagar,\nTanaji Nagar Road No 1, Near Time of India off, W.E. Highway,\nMalad East, Mumbai, Maharashtra - 400097',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF616161),
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
