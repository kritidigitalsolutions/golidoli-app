import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/shared/widgets/custom_button.dart';
import 'package:golidoli_app/utils/text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildUserHeader(controller),
                    SizedBox(height: 20),
                    _buildMenuList(controller),
                  ],
                ),
              ),
            ),
            _buildLogOutButton(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [Text('Profile', style: text16(fontWeight: FontWeight.w600))],
      ),
    );
  }

  Widget _buildUserHeader(ProfileController controller) {
    final user = controller.user;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user['avatar']),
                backgroundColor: AppColors.cardColor,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.backgroundColor,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '✦',
                      style: TextStyle(fontSize: 8, color: AppColors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user['name'],
                    style: text16(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  const Text('🔥', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Premium Member',
                    style: text11(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(ProfileController controller) {
    final icons = {
      'edit': Icons.edit_outlined,
      'subscription': Icons.card_membership_outlined,
      'language': Icons.language_outlined,
      'download': Icons.download_outlined,
      'content': Icons.tune_outlined,
      'settings': Icons.settings_outlined,
      'privacy': Icons.privacy_tip_outlined,
      'terms': Icons.description_outlined,
    };

    final items = controller.menuItems;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final icon = icons[item['icon']] ?? Icons.chevron_right;
          final hasTrailing = item['trailing'] != null;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              GestureDetector(
                onTap: () => controller.onMenuTap(item['label']),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.secondaryTextColor, size: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item['label'],
                          style: text14(color: AppColors.textColor),
                        ),
                      ),
                      if (hasTrailing) ...[
                        Text(
                          item['trailing'],
                          style: text13(color: AppColors.secondaryTextColor),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.secondaryTextColor,
                          size: 13,
                        ),
                      ] else
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.hintTextColor,
                          size: 13,
                        ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 0.6,
                  color: AppColors.secondaryTextColor.withOpacity(0.15),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLogOutButton(ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: AppButton(onTap: controller.onLogOut, title: 'Log Out'),
    );
  }
}

TextStyle text9({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) {
  return appTextStyle(fontSize: 9, fontWeight: fontWeight, color: color);
}
