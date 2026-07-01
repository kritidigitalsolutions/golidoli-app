import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildToggle(controller),
                    const SizedBox(height: 20),
                    _buildPlansRow(controller),
                    const SizedBox(height: 24),
                    _buildContinueButton(controller),
                    const SizedBox(height: 12),
                    _buildSecurePaymentNote(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                'Unlock Unlimited',
                style: text16(fontWeight: FontWeight.bold),
              ),
              Text('Entertainment', style: text16(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(SubscriptionController controller) {
    return Obx(
      () => Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _toggleOption(
              'Monthly',
              !controller.isYearly.value,
              controller.selectMonthly,
            ),
            _toggleOption(
              'Yearly',
              controller.isYearly.value,
              controller.selectYearly,
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleOption(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: text14(
                color: selected
                    ? AppColors.white
                    : AppColors.secondaryTextColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlansRow(SubscriptionController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildFreePlan()),
        const SizedBox(width: 12),
        Expanded(child: _buildPremiumPlan(controller)),
      ],
    );
  }

  Widget _buildFreePlan() {
    final features = [
      'Unlimited Content',
      'Ads Included',
      'SD Quality',
      'No Downloads',
      '1 Device Only',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Free Plan', style: text16(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹0', style: text20(fontWeight: FontWeight.bold)),
              Text('/month', style: text11(color: AppColors.hintTextColor)),
            ],
          ),
          const SizedBox(height: 14),
          ...features.map(
            (f) => _buildFeatureRow(f, color: AppColors.secondaryTextColor),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Center(
                child: Text(
                  'Current Plan',
                  style: text13(color: AppColors.secondaryTextColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPlan(SubscriptionController controller) {
    final features = [
      'Unlimited Movies',
      'All Web Series',
      'All Micro Dramas',
      'HD Streaming',
      'Ad-Free Experience',
      'Downloads',
      'Up to 4 Devices',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premium Plan',
            style: text16(
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Text(
                  controller.premiumPrice,
                  style: text20(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  controller.premiumPeriod,
                  style: text11(color: AppColors.hintTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...features.map(
            (f) => _buildFeatureRow(
              f,
              color: AppColors.white,
              checkColor: AppColors.accentColor,
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: controller.onContinueToPay,
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Upgrade Now',
                  style: text13(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    String label, {
    Color color = AppColors.white,
    Color checkColor = AppColors.secondaryTextColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_rounded, color: checkColor, size: 15),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label, style: text11(color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(SubscriptionController controller) {
    return GestureDetector(
      onTap: controller.onContinueToPay,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'Continue to Pay',
            style: text16(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurePaymentNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.hintTextColor,
          size: 13,
        ),
        const SizedBox(width: 5),
        Text(
          'Secure Payment | Cancel Anytime',
          style: text11(color: AppColors.hintTextColor),
        ),
      ],
    );
  }
}
