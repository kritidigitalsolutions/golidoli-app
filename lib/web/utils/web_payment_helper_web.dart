import 'dart:async';
import 'dart:js_interop';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/features/profile/repositories/payment_repo.dart';
import 'package:golidoli_app/web/utils/web_payment_result.dart';

@JS('openRazorpayWebCheckout')
external void _openRazorpayWebCheckout(
  JSAny options,
  JSFunction onSuccess,
  JSFunction onError,
);

class WebPaymentHelper {
  static final PaymentRepo _paymentRepo = PaymentRepo();

  /// Launches Razorpay payment for a given subscription plan on Web
  static Future<WebPaymentResult> purchasePlan({
    required SubscriptionPlan plan,
    String? userName,
    String? userEmail,
    String? userContact,
  }) async {
    try {
      // 1. Create order on backend
      final order = await _paymentRepo.createOrder(planId: plan.id);
      if (order == null) {
        return WebPaymentResult(
          success: false,
          errorMessage: 'Failed to initialize payment order on server',
        );
      }

      final String razorpayKey = order.razorpayKey.isNotEmpty
          ? order.razorpayKey
          : "rzp_test_1DP5mmOlF5G5ag";

      final int amountInPaise = order.amount > 0
          ? order.amount
          : (plan.price * 100).toInt();

      final completer = Completer<WebPaymentResult>();

      final optionsMap = {
        'key': razorpayKey,
        'amount': amountInPaise,
        'currency': order.currency.isNotEmpty ? order.currency : 'INR',
        if (order.orderId.isNotEmpty) 'order_id': order.orderId,
        'name': 'GoliDoli',
        'description': '${plan.name} VIP Subscription',
        'prefill': {
          'name': userName ?? '',
          'email': userEmail ?? '',
          'contact': userContact ?? '',
        },
        'theme': {
          'color': '#FF0564',
        },
      };

      final jsOptions = optionsMap.jsify();

      final onSuccess = ((JSString paymentId, JSString orderId, JSString signature) {
        final pId = paymentId.toDart;
        final oId = orderId.toDart;
        final sig = signature.toDart;

        // Verify on backend
        _paymentRepo
            .verifyPayment(
              razorpayOrderId: oId.isNotEmpty ? oId : order.orderId,
              razorpayPaymentId: pId,
              razorpaySignature: sig,
              planId: plan.id,
            )
            .then((verifyRes) {
              if (verifyRes != null && verifyRes.success) {
                if (!completer.isCompleted) {
                  completer.complete(WebPaymentResult(
                    success: true,
                    paymentId: pId,
                    orderId: oId,
                    signature: sig,
                  ));
                }
              } else {
                if (!completer.isCompleted) {
                  completer.complete(WebPaymentResult(
                    success: false,
                    errorMessage:
                        verifyRes?.message ?? 'Payment verification failed',
                  ));
                }
              }
            })
            .catchError((e) {
              if (!completer.isCompleted) {
                completer.complete(WebPaymentResult(
                  success: false,
                  errorMessage: 'Verification error: $e',
                ));
              }
            });
      }).toJS;

      final onError = ((JSString error) {
        if (!completer.isCompleted) {
          completer.complete(WebPaymentResult(
            success: false,
            errorMessage: error.toDart,
          ));
        }
      }).toJS;

      if (jsOptions != null) {
        _openRazorpayWebCheckout(jsOptions, onSuccess, onError);
      } else {
        return WebPaymentResult(
          success: false,
          errorMessage: 'Failed to serialize payment configuration',
        );
      }

      return await completer.future;
    } catch (e) {
      return WebPaymentResult(
        success: false,
        errorMessage: 'Payment error: ${e.toString()}',
      );
    }
  }
}
