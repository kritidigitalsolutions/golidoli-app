import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

class PlanController extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final allPlanStatus = Status.init.obs;
  final Rx<SubscriptionPlansResponse?> allPlans = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  final ProfileDatasource _api = ProfileDatasource();

  Future<void> fetchAllPlans({required String name}) async {
    allPlanStatus.value = Status.loading;
    final result = await _api.allSubscriptionPlans(name: name);
    if (result != null) {
      allPlans.value = result;
      allPlanStatus.value = Status.success;
    } else {
      allPlanStatus.value = Status.error;
    }
  }
}
