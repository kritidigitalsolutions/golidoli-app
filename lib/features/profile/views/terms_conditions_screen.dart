import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/widgets/profile_page_scaffold.dart';
import 'package:golidoli_app/utils/text_style.dart';

class TermsConditionsScreen extends StatelessWidget {
  TermsConditionsScreen({super.key});

  final TermsController controller = Get.put(TermsController());

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Terms & Conditions',

      children: [
        Text(
          'Please read these terms before using GoliDoli.',
          style: text13(color: AppColors.secondaryTextColor),
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
