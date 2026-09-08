import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/features/profile/repositories/payment_repo.dart';
import 'package:golidoli_app/web/utils/web_payment_helper.dart';

class PaymentController extends GetxController {
  final PaymentRepo _repo = PaymentRepo();
  Razorpay? _razorpay;

  final RxBool isProcessing = false.obs;
  String? _currentOrderId;
  String? planId;

  static const String defaultRazorpayKey = "rzp_test_1DP5mmOlF5G5ag";

  @override
  void onInit() {
    super.onInit();
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
    }
  }

  @override
  void onClose() {
    if (!kIsWeb) {
      _razorpay?.clear();
    }
    super.onClose();
  }

  /// Initiates payment for a SubscriptionPlan.
  Future<void> startPayment({
    required SubscriptionPlan plan,
    String? userEmail,
    String? userContact,
    String? userName,
  }) async {
    isProcessing.value = true;

    // Web Platform: use JavaScript Razorpay Checkout
    if (kIsWeb) {
      try {
        final result = await WebPaymentHelper.purchasePlan(
          plan: plan,
          userName: userName,
          userEmail: userEmail,
          userContact: userContact,
        );
        isProcessing.value = false;

        if (result.success) {
          try {
            Get.find<SubscriptionStatusController>().checkStatus();
          } catch (e) {
            debugPrint("Failed to refresh SubscriptionStatusController: $e");
          }
          Get.snackbar(
            'Payment Successful',
            'Subscription activated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
        } else {
          if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
            Get.snackbar(
              'Payment Notice',
              result.errorMessage!,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withValues(alpha: 0.8),
              colorText: Colors.white,
            );
          }
        }
      } catch (e) {
        isProcessing.value = false;
        Get.snackbar(
          'Payment Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
      return;
    }

    // Mobile Platform (Android / iOS)
    final order = await _repo.createOrder(planId: plan.id);

    String razorpayKey = (order != null && order.razorpayKey.isNotEmpty)
        ? order.razorpayKey
        : defaultRazorpayKey;

    int amountInPaise = (order != null && order.amount > 0)
        ? order.amount
        : (plan.price * 100).toInt();

    _currentOrderId = order?.orderId;
    planId = plan.id;

    final options = {
      'key': razorpayKey,
      'amount': amountInPaise,
      'currency': order?.currency ?? 'INR',
      if (_currentOrderId != null && _currentOrderId!.isNotEmpty)
        'order_id': _currentOrderId,
      'name': 'Golidoli',
      'description': '${plan.name} Subscription',
      'prefill': {
        'contact': userContact ?? '',
        'email': userEmail ?? '',
        'name': userName ?? '',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      isProcessing.value = false;
      debugPrint('Razorpay open error => $e');
      Get.snackbar(
        'Payment',
        'Unable to open payment screen: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    isProcessing.value = true;
    final orderId = response.orderId ?? _currentOrderId ?? '';

    if (orderId.isNotEmpty) {
      final result = await _repo.verifyPayment(
        razorpayOrderId: orderId,
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
        planId: planId ?? '',
      );
      isProcessing.value = false;

      if (result != null && result.success) {
        try {
          Get.find<SubscriptionStatusController>().checkStatus();
        } catch (e) {
          debugPrint("Failed to refresh SubscriptionStatusController: $e");
        }
        Get.snackbar(
          'Payment Successful',
          'Subscription activated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }
    }

    isProcessing.value = false;
    Get.snackbar(
      'Payment Successful',
      'Payment ID: ${response.paymentId}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _onPaymentError(PaymentFailureResponse response) {
    isProcessing.value = false;
    Get.snackbar(
      'Payment Failed',
      response.message ?? 'Payment failed or cancelled.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    isProcessing.value = false;
    Get.snackbar(
      'External Wallet',
      'Selected wallet: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
