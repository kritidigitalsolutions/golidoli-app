import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/features/profile/usecase/all_plan_usecase.dart';

class PlanController extends GetxController {
  final AllPlanUsecase _allPlanUsecase;

  PlanController({required AllPlanUsecase allPlanUsecase})
      : _allPlanUsecase = allPlanUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final allPlanStatus = Status.init.obs;
  final Rx<SubscriptionPlansResponse?> allPlans = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllPlans({required String name}) async {
    allPlanStatus.value = Status.loading;
    final result = await _allPlanUsecase(name: name);
    if (result != null) {
      allPlans.value = result;
      allPlanStatus.value = Status.success;
    } else {
      allPlanStatus.value = Status.error;
    }
  }
}
