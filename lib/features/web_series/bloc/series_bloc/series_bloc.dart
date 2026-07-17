import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/usecase/all_series_usecase.dart';
import 'package:golidoli_app/features/web_series/usecase/series_detail_usecase.dart';

import '../../model/SeriesModel.dart';

part 'series_event.dart';
part 'series_state.dart';
part 'series_bloc.freezed.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final AllSeriesUsecase _allSeriesUsecase;
  final SeriesDetailUsecase _seriesDetailUsecase;
  SeriesBloc({
    required AllSeriesUsecase allSeriesUsecase,
    required SeriesDetailUsecase seriesDetailUsecase,
  }) : _allSeriesUsecase = allSeriesUsecase,
       _seriesDetailUsecase = seriesDetailUsecase,
       super(SeriesState()) {
    on<_AllSeries>((event, emit) async {
      emit(state.copyWith(allSeriesStatus: Status.loading));
      final result = await _allSeriesUsecase();
      if (result != null) {
        emit(
          state.copyWith(allSeriesStatus: Status.success, allSeries: result),
        );
        debugPrint(result.toString());
      } else {
        emit(state.copyWith(allSeriesStatus: Status.error));
      }
    });
    on<_SeriesDetail>((event, emit) async {
      emit(state.copyWith(seriesDetailStatus: Status.loading));
      final result = await _seriesDetailUsecase(id: event.id);
      if (result != null) {
        emit(
          state.copyWith(
            seriesDetailStatus: Status.success,
            seriesDetail: result,
          ),
        );
        debugPrint(result.toString());
      } else {
        emit(state.copyWith(seriesDetailStatus: Status.error));
      }
    });
  }
}
