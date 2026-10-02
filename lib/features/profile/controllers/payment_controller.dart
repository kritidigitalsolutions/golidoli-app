import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/profile/controllers/subscription_status_controller.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/features/profile/repositories/payment_repo.dart';
import 'package:golidoli_app/web/utils/web_payment_helper.dart';

class PaymentController extends GetxController {
  final PaymentRepo _repo = PaymentRepo();
  final RxBool isProcessing = false.obs;
  Timer? _pollTimer;

  /// Initiates payment for a SubscriptionPlan.
  /// Flow: Creates order using AppUrl.createOrder, then opens website subscription / SabPaisa gateway via url_launcher.
  Future<void> startPayment({
    required SubscriptionPlan plan,
    String? userEmail,
    String? userContact,
    String? userName,
  }) async {
    isProcessing.value = true;

    try {
      final token = await StorageService.getToken();

      // Web Platform: use WebPaymentHelper (SabPaisa web checkout)
      if (kIsWeb) {
        final result = await WebPaymentHelper.purchasePlan(
          plan: plan,
          userName: userName,
          userEmail: userEmail,
          userContact: userContact,
          openInSameTab: true,
        );
        isProcessing.value = false;

        if (result.success) {
          Get.snackbar(
            'Redirecting to SabPaisa',
            'Opening payment gateway...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withValues(alpha: 0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
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
        return;
      }

      // Mobile Platform: Create Order / get payment URL using AppUrl.createOrder
      final orderResponse = await _repo.createOrder(
        planId: plan.id,
        userName: userName,
        userEmail: userEmail,
        userContact: userContact,
      );

      String txnId = '';
      if (orderResponse != null) {
        txnId = orderResponse.transId.isNotEmpty ? orderResponse.transId : orderResponse.orderId;
        if (txnId.isNotEmpty) {
          await StorageService.savePendingPayment(
            txnId: txnId,
            planId: plan.id,
          );
        }
      }

      String paymentUrl = '';
      if (orderResponse != null && orderResponse.paymentUrl.isNotEmpty) {
        paymentUrl = orderResponse.paymentUrl;
      } else {
        // Fallback to website subscription page with planId & token
        paymentUrl = AppUrl.webSubscriptionUrl(planId: plan.id, token: token);
      }

      final uri = Uri.parse(paymentUrl);
      if (await canLaunchUrl(uri)) {
        isProcessing.value = false;
        Get.snackbar(
          'Redirecting to SabPaisa',
          'Opening payment gateway...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        if (txnId.isNotEmpty) {
          startPollingVerification(txnId, plan.id);
        }

        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        isProcessing.value = false;
        Get.snackbar(
          'Payment Error',
          'Could not launch payment gateway URL.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isProcessing.value = false;
      debugPrint("PaymentController error: $e");
      Get.snackbar(
        'Payment Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Automatically polls verifyPayment every 3s after user launches payment gateway
  void startPollingVerification(String txnId, String planId) {
    _pollTimer?.cancel();
    int count = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      count++;
      if (count > 25) {
        timer.cancel();
        return;
      }

      debugPrint("Auto-polling verifyPayment (#$count): txnId=$txnId, planId=$planId");
      try {
        final verifyRes = await _repo.verifyPayment(
          transactionId: txnId,
          planId: planId,
        );

        if (verifyRes != null && verifyRes.success) {
          timer.cancel();
          await StorageService.clearPendingPayment();
          await Get.find<SubscriptionStatusController>().checkStatus();
          Get.snackbar(
            'Payment Verified!',
            'Your VIP subscription is active!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
          return;
        }

        await Get.find<SubscriptionStatusController>().checkStatus();
        if (Get.find<SubscriptionStatusController>().isPremiumUser.value) {
          timer.cancel();
          await StorageService.clearPendingPayment();
          Get.snackbar(
            'Subscription Active!',
            'Your VIP subscription is active!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
        }
      } catch (e) {
        debugPrint("Polling verify error: $e");
      }
    });
  }

  /// Manually verifies and checks subscription status upon returning from payment gateway
  Future<void> checkAndUpdateStatus() async {
    try {
      await Get.find<SubscriptionStatusController>().checkStatus();
      final isSubscribed = Get.find<SubscriptionStatusController>().isPremiumUser.value;
      if (isSubscribed) {
        Get.snackbar(
          'Subscription Active',
          'Your VIP subscription is successfully active!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Status Check',
          'Subscription status checked.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Check status error: $e");
    }
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
