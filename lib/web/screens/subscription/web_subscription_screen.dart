import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/profile/controllers/plan_controller.dart';
import 'package:golidoli_app/features/profile/controllers/profile_controller.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/shared/widgets/shimmer/shimmer.dart';
import 'package:golidoli_app/utils/text_style.dart';
import 'package:golidoli_app/web/layouts/web_main_layout.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';
import 'package:golidoli_app/web/utils/web_auth_guard.dart';
import 'package:golidoli_app/web/utils/web_payment_helper.dart';
import 'package:golidoli_app/web/utils/web_responsive.dart';

class WebSubscriptionScreen extends StatefulWidget {
  const WebSubscriptionScreen({super.key});

  @override
  State<WebSubscriptionScreen> createState() => _WebSubscriptionScreenState();
}

class _WebSubscriptionScreenState extends State<WebSubscriptionScreen> {
  late final PlanController _planController;
  final Set<String> _expandedPlanIds = {};
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    _planController = Get.isRegistered<PlanController>()
        ? Get.find<PlanController>()
        : Get.put(PlanController());

    _planController.fetchAllPlans().then((_) {
      if (_planController.selectedPlan.value != null && mounted) {
        setState(() {
          _expandedPlanIds.add(_planController.selectedPlan.value!.id);
        });
      }
    });

    // Ensure status controller is registered
    if (!Get.isRegistered<SubscriptionStatusController>()) {
      Get.put(SubscriptionStatusController());
    }
  }

  Future<void> _startPayment() async {
    await WebAuthGuard.requireAuth(
      context: context,
      message: 'Please sign in to purchase a subscription plan and unlock VIP content.',
      onSuccess: () {
        _processPurchase();
      },
    );
  }

  Future<void> _processPurchase() async {
    final subStatusController = Get.find<SubscriptionStatusController>();
    if (subStatusController.isPremiumUser.value) {
      Get.snackbar(
        'Subscription Active',
        'You already have an active subscription plan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accentColor.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    final selectedPlan = _planController.selectedPlan.value ??
        _planController.allPlans.value?.plans.firstOrNull;

    if (selectedPlan == null) {
      Get.snackbar(
        'Notice',
        'No subscription plan selected.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      final user = await StorageService.getUser();
      final result = await WebPaymentHelper.purchasePlan(
        plan: selectedPlan,
        userName: user?.name,
        userEmail: user?.email,
        userContact: user?.phone,
      );

      if (result.success) {
        // Refresh subscription and profile state
        await subStatusController.checkStatus();
        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().fetchProfile();
        }

        if (mounted) {
          _showPaymentSuccessDialog(selectedPlan);
        }
      } else {
        if (mounted && result.errorMessage != null && result.errorMessage!.isNotEmpty) {
          Get.snackbar(
            'Payment Failed',
            result.errorMessage ?? 'Payment could not be completed.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.errorColor.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint("Web payment error: $e");
      if (mounted) {
        Get.snackbar(
          'Error',
          'Payment error: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorColor.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessingPayment = false);
      }
    }
  }

  void _showPaymentSuccessDialog(SubscriptionPlan plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 440,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppColors.primaryColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to VIP!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your subscription to "${plan.name}" is now active. Enjoy unlimited ad-free movies, web series, and exclusive micro dramas.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.secondaryTextColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(WebRoutes.profile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Go to Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = WebResponsive.contentHorizontalPadding(context);

    return WebMainLayout(
      activeRoute: WebRoutes.subscription,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 32,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildBanner(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    'Select a Plan',
                    style: text18(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                _buildPlansList(),
                const SizedBox(height: 24),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Get.back();
            } else {
              Get.toNamed(WebRoutes.home);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.borderColor.withOpacity(0.4),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'Choose your plan',
          style: text20(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceColor,
            AppColors.cardColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: AppColors.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock Premium Experience',
                  style: text16(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enjoy ad-free streaming, HD quality & all content on Mobile and Web.',
                  style: text13(color: AppColors.secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList() {
    return Obx(() {
      final status = _planController.allPlanStatus.value;

      if (status == Status.loading) {
        return const SubscriptionPlansShimmer();
      }

      if (status == Status.error) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.errorColor,
                  size: 44,
                ),
                const SizedBox(height: 12),
                Text(
                  'Failed to load subscription plans',
                  style: text14(color: AppColors.secondaryTextColor),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _planController.fetchAllPlans(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.black,
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      }

      final plans = _planController.allPlans.value?.plans ?? [];
      if (plans.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  color: AppColors.hintTextColor,
                  size: 44,
                ),
                const SizedBox(height: 12),
                Text(
                  'No subscription plans available right now.',
                  style: text14(color: AppColors.secondaryTextColor),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _planController.fetchAllPlans(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.black,
                  ),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
        );
      }

      final selectedPlan = _planController.selectedPlan.value;

      return Column(
        children: plans.map((plan) {
          final isSelected = selectedPlan?.id == plan.id;
          return _buildPlanCard(plan: plan, isSelected: isSelected);
        }).toList(),
      );
    });
  }

  Widget _buildPlanCard({
    required SubscriptionPlan plan,
    required bool isSelected,
  }) {
    final hasFeatures = plan.features.isNotEmpty;
    final isExpanded = _expandedPlanIds.contains(plan.id);
    final durationLabel = plan.duration > 0
        ? '${plan.duration} ${plan.duration == 1 ? 'Day' : 'Days'}'
        : plan.planType.toUpperCase();

    return GestureDetector(
      onTap: () {
        _planController.selectPlan(plan);
        setState(() {
          if (!_expandedPlanIds.contains(plan.id)) {
            _expandedPlanIds.add(plan.id);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceColor
              : AppColors.cardColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.borderColor.withOpacity(0.4),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Badges & Radio Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Plan Type / Duration Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor.withOpacity(0.2)
                            : AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.5)
                              : AppColors.borderColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        durationLabel,
                        style: text11(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.secondaryTextColor,
                        ),
                      ),
                    ),
                    if (plan.isRecommended) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'RECOMMENDED',
                          style: text9(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Selection Radio Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.hintTextColor,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: AppColors.black,
                          ),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Plan Title & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: text18(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.white : AppColors.secondaryTextColor,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹${plan.price}',
                      style: text26(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/${plan.duration}d',
                      style: text12(color: AppColors.hintTextColor),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(
              color: AppColors.dividerColor.withOpacity(0.5),
              height: 1,
            ),
            const SizedBox(height: 10),

            // Expandable Features Toggle Header
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  if (_expandedPlanIds.contains(plan.id)) {
                    _expandedPlanIds.remove(plan.id);
                  } else {
                    _expandedPlanIds.add(plan.id);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hasFeatures
                          ? 'Features (${plan.features.length})'
                          : 'Plan Features',
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.secondaryTextColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          isExpanded ? 'Hide' : 'View',
                          style: text12(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.hintTextColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Expandable Features List
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasFeatures)
                      ...plan.features.map(
                        (f) => _buildFeatureRow(
                          f,
                          color: AppColors.white,
                          checkColor: isSelected
                              ? AppColors.primaryColor
                              : AppColors.accentColor,
                        ),
                      )
                    else ...[
                      _buildFeatureRow(
                        'Unlimited Movies, Series & Micro Dramas',
                        color: AppColors.white,
                        checkColor: isSelected
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      ),
                      _buildFeatureRow(
                        'Full HD Streaming & Ad-Free Experience',
                        color: AppColors.white,
                        checkColor: isSelected
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      ),
                      _buildFeatureRow(
                        'Watch on Mobile, Tablet, Laptop and Desktop',
                        color: AppColors.white,
                        checkColor: isSelected
                            ? AppColors.primaryColor
                            : AppColors.accentColor,
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: checkColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: text13(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final isSubscribed =
          Get.find<SubscriptionStatusController>().isPremiumUser.value;
      final selectedPlan = _planController.selectedPlan.value;

      String buttonText;
      if (isSubscribed) {
        buttonText = 'Active Plan';
      } else if (selectedPlan != null) {
        buttonText = 'Pay ₹${selectedPlan.price} • Continue';
      } else {
        buttonText = 'Continue';
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            if (selectedPlan != null && !isSubscribed) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Amount',
                    style: text11(color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${selectedPlan.price}',
                    style: text20(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
            ],
            Expanded(
              child: GestureDetector(
                onTap: _isProcessingPayment || isSubscribed ? null : _startPayment,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSubscribed
                        ? AppColors.surfaceColor
                        : AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isSubscribed
                        ? Border.all(color: AppColors.borderColor)
                        : null,
                  ),
                  child: Center(
                    child: _isProcessingPayment
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.black,
                            ),
                          )
                        : Text(
                            buttonText,
                            style: text15(
                              color: isSubscribed
                                  ? AppColors.white
                                  : AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
}
