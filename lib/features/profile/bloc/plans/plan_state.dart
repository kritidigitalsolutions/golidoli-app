part of 'plan_bloc.dart';

@freezed
abstract class PlanState with _$PlanState {
  const factory PlanState({
    @Default(Status.init) Status allPlanStatus,
    @Default(null) SubscriptionPlansResponse? allPlans,
  }) = _PlanState;
}
