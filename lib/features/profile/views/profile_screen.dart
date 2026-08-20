import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/fetch_profile_controller.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/shared/widgets/custom_button.dart';
import 'package:golidoli_app/utils/text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final FetchProfileController controllers = Get.put(
      FetchProfileController(),
    );
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
                    _buildUserHeader(controllers),
                    _buildSubscriptionCard(),
                    const SizedBox(height: 10),
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

  Widget _buildUserHeader(FetchProfileController controller) {
    return Obx(() {
      final user = controller.user.value;

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (user == null) {
        return const Center(child: Text("No user found"));
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cardColor,
                  backgroundImage: user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : null,
                  child: user.profileImage.isEmpty
                      ? const Icon(Icons.person)
                      : null,
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
                    Text(user.name, style: text16(fontWeight: FontWeight.bold)),
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
                      user.role,
                      style: text11(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuList(ProfileController controller) {
    final icons = {
      'edit': Icons.edit_outlined,
      'subscription': Icons.card_membership_outlined,
      'language': Icons.language_outlined,
      'download': Icons.download_outlined,
      //'content': Icons.tune_outlined,
      'settings': Icons.settings_outlined,
      'privacy': Icons.privacy_tip_outlined,
      'terms': Icons.description_outlined,
      'refund': Icons.money_off_outlined,
      "FAQ's": Icons.question_answer_outlined,
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

  Widget _buildSubscriptionCard() {
    final subController = Get.find<SubscriptionStatusController>();
    return Obx(() {
      if (subController.isLoading.value) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accentColor),
          ),
        );
      }

      final isPremium = subController.isPremiumUser.value;
      final status = subController.subscriptionStatus.value;

      if (isPremium && status != null && status.subscription != null) {
        final sub = status.subscription!;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentColor.withOpacity(0.5),
              width: 1.5,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: AppColors.accentColor.withOpacity(0.15),
            //     blurRadius: 10,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: AppColors.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        sub.plan.name,
                        style: text15(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: text10(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: AppColors.white.withOpacity(0.1), height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining Days',
                        style: text10(color: AppColors.hintTextColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${status.remainingDays} Days',
                        style: text16(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Renews On',
                        style: text10(color: AppColors.hintTextColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(sub.endDate),
                        style: text12(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }

      // Unsubscribed user promo card
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'No Active Subscription',
                  style: text14(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Unlock all premium widescreen movies, web series, and vertical dramas with zero ads.',
              style: text11(color: AppColors.secondaryTextColor),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.subscription),
              child: Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentColor, Color(0xFFFF5E97)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Upgrade to Premium',
                    style: text12(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
    } catch (e) {
      return dateStr.split('T').first;
    }
  }
}

TextStyle text9({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textColor,
}) {
  return appTextStyle(fontSize: 9, fontWeight: fontWeight, color: color);
}
