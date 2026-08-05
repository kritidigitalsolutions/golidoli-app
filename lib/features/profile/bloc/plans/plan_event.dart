part of 'plan_bloc.dart';

@freezed
abstract class PlanEvent with _$PlanEvent {
  const factory PlanEvent.allPlans({required String name}) = _AllPlans;
}
