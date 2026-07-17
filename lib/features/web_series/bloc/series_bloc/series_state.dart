part of 'series_bloc.dart';

@freezed
abstract class SeriesState with _$SeriesState {
  const factory SeriesState({
    @Default(null) SeriesResponse? allSeries,
    @Default(null) Series? seriesDetail,
    @Default(Status.init) Status allSeriesStatus,
    @Default(Status.init) Status seriesDetailStatus,
  }) = _SeriesState;
}
