import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';
import 'package:golidoli_app/features/web_series/usecase/all_episode_usecase.dart';
import 'package:golidoli_app/features/web_series/usecase/detail_episode_usecase.dart';

import '../../model/episode_model.dart';

part 'episode_event.dart';
part 'episode_state.dart';
part 'episode_bloc.freezed.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final AllEpisodeUsecase _allEpisodeUsecase;
  final DetailEpisodeUsecase _detailEpisodeUsecase;
  EpisodeBloc({required AllEpisodeUsecase allEpisodeUsecase,required DetailEpisodeUsecase detailEpisodeUsecase})
    : _allEpisodeUsecase = allEpisodeUsecase,
  _detailEpisodeUsecase=detailEpisodeUsecase,
      super(EpisodeState()) {
    on<_AllEpisode>((event, emit) async {
      emit(state.copyWith(allEpisodeStatus: Status.loading));
      final result = await _allEpisodeUsecase(id: event.id);
      if (result != null) {
        emit(
          state.copyWith(allEpisode: result, allEpisodeStatus: Status.success),
        );
      } else {
        emit(state.copyWith(allEpisodeStatus: Status.error));
      }
    });
    on<_EpisodeDetail>((event,emit)async{
      emit(state.copyWith(detailEpisode: Status.loading));
      final result=await _detailEpisodeUsecase(id: event.id);
      if(result!=null){
        emit(state.copyWith(episodeDetail: result,detailEpisode: Status.success));
      }else{
        emit(state.copyWith(detailEpisode: Status.error));
      }
    });
  }
}
