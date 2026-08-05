import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/plan_model.dart';
import 'package:golidoli_app/features/profile/usecase/all_plan_usecase.dart';

part 'plan_event.dart';
part 'plan_state.dart';
part 'plan_bloc.freezed.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final AllPlanUsecase _allPlanUsecase;
  PlanBloc({required AllPlanUsecase allPlanUsecase})
    : _allPlanUsecase = allPlanUsecase,
      super(const PlanState()) {
    on<_AllPlans>((event, emit) async {
      emit(state.copyWith(allPlanStatus: Status.loading));
      final result = await _allPlanUsecase(name: event.name);
      if (result != null) {
        emit(state.copyWith(allPlanStatus: Status.success, allPlans: result));
      } else {
        emit(state.copyWith(allPlanStatus: Status.error));
      }
    });
  }
}
