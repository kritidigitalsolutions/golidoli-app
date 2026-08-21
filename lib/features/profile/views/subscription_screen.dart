import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/controllers/fetch_profile_controller.dart';
import 'package:golidoli_app/features/profile/controllers/payment_controller.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/utils/text_style.dart';
import '../controllers/plan_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearly = false;
  late final PlanController _controller;
  late final PaymentController _paymentController;
  late final FetchProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(PlanController());
    _paymentController = Get.put(PaymentController());
    _profileController = Get.put(FetchProfileController());
    _controller.fetchAllPlans(name: 'monthly');
  }

  void startPayment() {
    if (Get.find<SubscriptionStatusController>().isPremiumUser.value) {
      Get.snackbar(
        'Subscription Active',
        'You already have an active subscription plan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accentColor.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final plans = _controller.allPlans.value?.plans;
    if (plans == null || plans.isEmpty) {
      Get.snackbar(
        'Notice',
        'No subscription plan available to purchase.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final selectedPlan = plans.first;
    final user = _profileController.user.value;

    _paymentController.startPayment(
      plan: selectedPlan,
      userContact: user?.phone,
      userEmail: user?.email,
      userName: user?.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildToggle()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: _buildPremiumPlan(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: _buildContinueButton(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text('Choose your plan', style: text18(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ─── Banner ────────────────────────────────────────────────────────
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.stars_rounded,
            color: AppColors.primaryColor,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock Premium Experience',
                  style: text14(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enjoy ads free streaming & downloads',
                  style: text11(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Toggle ────────────────────────────────────────────────────────
  Widget _buildToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          _toggleOption('Monthly', !_isYearly, () {
            setState(() => _isYearly = false);
            _controller.fetchAllPlans(name: 'monthly');
          }),
          _toggleOption('Yearly', _isYearly, () {
            setState(() => _isYearly = true);
            _controller.fetchAllPlans(name: 'yearly');
          }),
        ],
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
            color: selected ? AppColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: text12(
                color: selected
                    ? AppColors.black
                    : AppColors.secondaryTextColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Premium Plan ──────────────────────────────────────────────────
  Widget _buildPremiumPlan() {
    return Obx(() {
      final status = _controller.allPlanStatus.value;
      final isMonthly = !_isYearly;
      final periodText = isMonthly ? '/month' : '/year';

      // Determine price from state
      String priceText = '0';
      bool isLoading = status == Status.loading;
      bool hasError =
          status == Status.error ||
          _controller.allPlans.value == null ||
          _controller.allPlans.value!.plans.isEmpty;

      if (!isLoading && !hasError) {
        final plan = _controller.allPlans.value!.plans.first;
        priceText = '${plan.price}';
      }

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
            // Price and period
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    '₹$priceText',
                    style: text20(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                const SizedBox(width: 4),
                Text(periodText, style: text11(color: AppColors.hintTextColor)),
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
              onTap: startPayment,
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Obx(() {
                    if (_paymentController.isProcessing.value) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.black,
                        ),
                      );
                    }
                    final isSubscribed =
                        Get.find<SubscriptionStatusController>()
                            .isPremiumUser
                            .value;
                    if (isSubscribed) {
                      return Text(
                        'Active Plan',
                        style: text13(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return Text(
                      'Upgrade Now',
                      style: text13(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ─── Feature Row ──────────────────────────────────────────────────
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

  // ─── Continue Button ──────────────────────────────────────────────
  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: startPayment,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Obx(() {
            if (_paymentController.isProcessing.value) {
              return const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.black,
                ),
              );
            }
            final isSubscribed =
                Get.find<SubscriptionStatusController>().isPremiumUser.value;
            return Text(
              isSubscribed ? 'Active Plan' : 'Continue',
              style: text13(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ),
      ),
    );
  }
}
