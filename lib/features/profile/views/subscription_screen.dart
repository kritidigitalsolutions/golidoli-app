import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/utils/text_style.dart';

import '../bloc/plans/plan_bloc.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isYearly = false;

  @override
  void initState() {
    super.initState();
    // Fetch monthly plan by default
    context.read<PlanBloc>().add(const PlanEvent.allPlans(name: 'monthly'));
  }

  @override
  Widget build(BuildContext context) {
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
                    _buildToggle(),
                    const SizedBox(height: 20),
                    _buildPlansRow(),
                    const SizedBox(height: 24),
                    _buildContinueButton(),
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

  // ─── App Bar ──────────────────────────────────────────────────────────
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

  // ─── Toggle ──────────────────────────────────────────────────────────
  Widget _buildToggle() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _toggleOption(
            'Monthly',
            !_isYearly,
                () {
              setState(() => _isYearly = false);
              // Fetch monthly plan
              context.read<PlanBloc>().add(const PlanEvent.allPlans(name: 'monthly'));
            },
          ),
          _toggleOption(
            'Yearly',
            _isYearly,
                () {
              setState(() => _isYearly = true);
              // Fetch yearly plan
              context.read<PlanBloc>().add(const PlanEvent.allPlans(name: 'yearly'));
            },
          ),
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

  // ─── Plans Row ──────────────────────────────────────────────────────
  Widget _buildPlansRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildFreePlan()),
        const SizedBox(width: 12),
        Expanded(child: _buildPremiumPlan()),
      ],
    );
  }

  // ─── Free Plan (static) ─────────────────────────────────────────────
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
          Container(
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
        ],
      ),
    );
  }

  // ─── Premium Plan (from BLoC) ──────────────────────────────────────
  Widget _buildPremiumPlan() {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        final isMonthly = !_isYearly;
        final periodText = isMonthly ? '/month' : '/year';

        // Determine price from state
        String priceText = '0';
        bool isLoading = state.allPlanStatus == Status.loading;
        bool hasError = state.allPlanStatus == Status.error || state.allPlans == null || state.allPlans!.plans.isEmpty;

        if (!isLoading && !hasError) {
          final plan = state.allPlans!.plans.first;
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
                  Text(
                    periodText,
                    style: text11(color: AppColors.hintTextColor),
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
                onTap: () {
                  // Handle upgrade
                },
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
      },
    );
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
      onTap: () {
        // Handle continue
      },
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

  // ─── Secure Payment Note ──────────────────────────────────────────
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