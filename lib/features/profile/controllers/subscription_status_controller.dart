import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/profile/models/response/subscription_status_model.dart';
import 'package:golidoli_app/features/profile/repositories/payment_repo.dart';
import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

class SubscriptionStatusController extends GetxController {
  final ProfileDatasource _datasource = ProfileDatasource();
  final PaymentRepo _paymentRepo = PaymentRepo();

  final RxBool isLoading = false.obs;
  final Rxn<SubscriptionStatusResponse> subscriptionStatus = Rxn<SubscriptionStatusResponse>();
  final RxBool isPremiumUser = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkStatus();
  }

  Future<void> checkStatus() async {
    try {
      isLoading.value = true;

      // Check if there is a pending payment verification
      final pending = await StorageService.getPendingPayment();
      if (pending != null) {
        final txnId = pending['txnId'];
        final planId = pending['planId'];
        if (txnId != null && txnId.isNotEmpty && planId != null && planId.isNotEmpty) {
          debugPrint("Verifying pending payment before fetching status: txnId=$txnId, planId=$planId");
          final verifyRes = await _paymentRepo.verifyPayment(
            transactionId: txnId,
            planId: planId,
          );
          if (verifyRes != null && verifyRes.success) {
            await StorageService.clearPendingPayment();
          }
        }
      }

      final result = await _datasource.fetchSubscriptionStatus();
      if (result != null) {
        subscriptionStatus.value = result;
        // A user is premium if the API returns success and the active subscription exists and is active.
        isPremiumUser.value = result.success &&
            result.subscription != null &&
            result.subscription!.status.toLowerCase() == 'active';
        if (isPremiumUser.value) {
          await StorageService.clearPendingPayment();
        }
      } else {
        isPremiumUser.value = false;
        subscriptionStatus.value = null;
      }
    } catch (e) {
      debugPrint("SubscriptionStatusController checkStatus error: $e");
      isPremiumUser.value = false;
      subscriptionStatus.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
