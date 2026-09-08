import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/web/utils/web_payment_result.dart';

class WebPaymentHelper {
  static Future<WebPaymentResult> purchasePlan({
    required SubscriptionPlan plan,
    String? userName,
    String? userEmail,
    String? userContact,
  }) async {
    return WebPaymentResult(
      success: false,
      errorMessage: 'Web payments are not available on this platform.',
    );
  }
}
