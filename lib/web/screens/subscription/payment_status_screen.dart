import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/features/profile/repositories/payment_repo.dart';
import 'package:golidoli_app/web/routes/web_routes.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({super.key});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  final PaymentRepo _repo = PaymentRepo();
  bool _isVerifying = true;
  bool _isSuccess = false;
  String _message = 'Verifying your payment...';

  @override
  void initState() {
    super.initState();
    _verifyPayment();
  }

  Map<String, String> _getAllQueryParams() {
    final params = <String, String>{};
    params.addAll(Uri.base.queryParameters);

    final fragment = Uri.base.fragment;
    if (fragment.contains('?')) {
      final queryString = fragment.substring(fragment.indexOf('?') + 1);
      final fragmentUri = Uri.parse('http://dummy.com/?$queryString');
      params.addAll(fragmentUri.queryParameters);
    }

    Get.parameters.forEach((key, value) {
      if (value != null) {
        params[key] = value;
      }
    });
    return params;
  }

  Future<void> _verifyPayment() async {
    setState(() {
      _isVerifying = true;
      _message = 'Verifying your payment with SabPaisa...';
    });

    try {
      final queryParams = _getAllQueryParams();
      final pending = await StorageService.getPendingPayment();

      String? txnId = queryParams['txnId'] ??
          queryParams['clientTxnId'] ??
          queryParams['merchantTxnId'] ??
          queryParams['transactionId'] ??
          queryParams['paymentId'] ??
          queryParams['orderId'] ??
          pending?['txnId'];

      final planId = queryParams['planId'] ?? pending?['planId'] ?? '';
      final paymentId = queryParams['paymentId'] ?? pending?['paymentId'];

      debugPrint("PaymentStatusScreen verifying: txnId=$txnId, planId=$planId, params=$queryParams");

      final verifyRes = await _repo.verifyPayment(
        transactionId: txnId ?? '',
        planId: planId,
        paymentId: paymentId,
        extraData: queryParams,
      );

      if (verifyRes != null && verifyRes.success) {
        await StorageService.clearPendingPayment();
        await Get.find<SubscriptionStatusController>().checkStatus();
        if (mounted) {
          setState(() {
            _isVerifying = false;
            _isSuccess = true;
            _message = verifyRes.message.isNotEmpty
                ? verifyRes.message
                : 'Payment verified successfully!';
          });
        }
        return;
      }

      // Check subscription status as fallback
      await Get.find<SubscriptionStatusController>().checkStatus();
      final isPremium = Get.find<SubscriptionStatusController>().isPremiumUser.value;

      if (mounted) {
        if (isPremium) {
          await StorageService.clearPendingPayment();
          setState(() {
            _isVerifying = false;
            _isSuccess = true;
            _message = 'Your VIP subscription is active!';
          });
        } else {
          setState(() {
            _isVerifying = false;
            _isSuccess = false;
            _message = 'Payment verification pending. If you completed payment, please try again in a few moments.';
          });
        }
      }
    } catch (e) {
      debugPrint("PaymentStatusScreen verify error: $e");
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isSuccess = false;
          _message = 'Error verifying payment: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Container(
          width: 440,
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.borderColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isVerifying) ...[
                const CircularProgressIndicator(color: AppColors.primaryPink),
                const SizedBox(height: 24),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ] else if (_isSuccess) ...[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(WebRoutes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Start Watching VIP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    color: Colors.orange,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Verification',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _verifyPayment,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primaryPink),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Retry Verification',
                          style: TextStyle(color: AppColors.primaryPink),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed(WebRoutes.home),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Go to Home',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
