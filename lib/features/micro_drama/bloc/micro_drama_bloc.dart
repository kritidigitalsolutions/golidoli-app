import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/features/micro_drama/usecases/all_micro_drama_usecase.dart';
import 'package:golidoli_app/features/micro_drama/usecases/detail_drama_usecase.dart';
import 'package:golidoli_app/features/micro_drama/usecases/drama_episode_detail.dart';

import '../../web_series/model/episode_response.dart';
import '../models/micro_drama_detail_response.dart';

part 'micro_drama_event.dart';
part 'micro_drama_state.dart';
part 'micro_drama_bloc.freezed.dart';

class MicroDramaBloc extends Bloc<MicroDramaEvent, MicroDramaState> {
  final AllMicroDramaUsecase _allMicroDramaUsecase;
  final DetailDramaUsecase _detailDramaUsecase;
  final DramaEpisodeDetail _dramaEpisodeDetail;
  MicroDramaBloc({
    required DramaEpisodeDetail dramaEpisodeDetail,
    required AllMicroDramaUsecase allMicroDramaUsecase,
    required DetailDramaUsecase detailDramaUsecase,
  }) : _allMicroDramaUsecase = allMicroDramaUsecase,
       _detailDramaUsecase = detailDramaUsecase,
       _dramaEpisodeDetail = dramaEpisodeDetail,
       super(const MicroDramaState()) {
    on<_AllMicroDrama>((event, emit) async {
      emit(state.copyWith(allMicroDramaStatus: Status.loading));
      final result = await _allMicroDramaUsecase();

      emit(
        state.copyWith(
          allMicroDramaStatus: Status.success,
          allMicroDrama: result,
        ),
      );
    });
    on<_DetailMicroDrama>((event, emit) async {
      emit(state.copyWith(detailDramaStatus: Status.loading));
      final result = await _detailDramaUsecase(id: event.id);
      if (result != null) {
        emit(
          state.copyWith(
            detailDramaStatus: Status.success,
            dramaDetail: result,
          ),
        );
      } else {
        emit(state.copyWith(detailDramaStatus: Status.error));
      }
    });
    on<_EpisodeDetail>((event, emit) async {
      emit(state.copyWith(episodeDetailStatus: Status.loading));
      final result = await _dramaEpisodeDetail.call(id: event.id);
      if (result != null) {
        emit(
          state.copyWith(
            episodeDetailStatus: Status.success,
            episodeDetail: result,
          ),
        );
      } else {
        emit(state.copyWith(episodeDetailStatus: Status.error));
      }
    });
  }
}
