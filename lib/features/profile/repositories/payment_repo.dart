import 'package:flutter/foundation.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/data/network/network_api_service.dart';

class PaymentRepo {
  final NetworkApiService _apiService = NetworkApiService();

  /// Creates a Razorpay order on the backend for the selected plan.
  /// Returns the order details (order id, amount, currency, Razorpay key)
  /// needed to open the Razorpay checkout, or null on failure.
  Future<CreateOrderResponse?> createOrder({required String planId}) async {
    try {
      final response = await _apiService.postApi(AppUrl.createOrder, {
        'planId': planId,
        "promoCode": "",
      });
      return CreateOrderResponse.fromJson(response);
    } catch (e) {
      debugPrint('PaymentRepo.createOrder error => $e');
      return null;
    }
  }

  /// Verifies the payment signature Razorpay returns after a successful
  /// checkout, against the backend. Returns null on a network/unexpected
  /// failure; check `.success` on the result for a completed-but-invalid
  /// payment.
  Future<VerifyPaymentResponse?> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final response = await _apiService.postApi(AppUrl.verifyPayment, {
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
      });
      return VerifyPaymentResponse.fromJson(response);
    } catch (e) {
      debugPrint('PaymentRepo.verifyPayment error => $e');
      return null;
    }
  }
}

class VerifyPaymentResponse {
  const VerifyPaymentResponse({required this.success, required this.message});

  final bool success;
  final String message;

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      success: json['success'] == true || json['status'] == 'success',
      message: (json['message'] ?? '').toString(),
    );
  }
}

class CreateOrderResponse {
  const CreateOrderResponse({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.razorpayKey,
  });

  final String orderId;
  final int amount;
  final String currency;
  final String razorpayKey;

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    final order = json['order'] is Map<String, dynamic>
        ? json['order'] as Map<String, dynamic>
        : null;

    final String orderId = (order != null
            ? (order['id'] ?? order['orderId'] ?? order['order_id'])
            : (json['orderId'] ?? json['order_id'] ?? json['id'] ?? ''))
        .toString();

    final dynamic rawAmount = order != null ? order['amount'] : json['amount'];
    final int amount = rawAmount is int
        ? rawAmount
        : int.tryParse('$rawAmount') ?? 0;

    final String currency = (order != null
            ? (order['currency'] ?? 'INR')
            : (json['currency'] ?? 'INR'))
        .toString();

    final String razorpayKey = (json['key'] ?? json['razorpayKey'] ?? '').toString();

    return CreateOrderResponse(
      orderId: orderId,
      amount: amount,
      currency: currency,
      razorpayKey: razorpayKey,
    );
  }
}
