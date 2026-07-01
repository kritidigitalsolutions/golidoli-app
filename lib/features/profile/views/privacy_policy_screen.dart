import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final PrivacyController controller = Get.put(PrivacyController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Privacy Policy',

      children: [
        Text(
          'Last updated: June 2026',
          style: text12(color: AppColors.secondaryTextColor),
        ),
        const SizedBox(height: 14),
        ...controller.sections.map(
          (section) => ProfileSurfaceTile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section['title'] ?? '',
                  style: text15(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  section['body'] ?? '',
                  style: text13(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
