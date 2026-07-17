part of 'series_bloc.dart';

@freezed
class SeriesEvent with _$SeriesEvent {
  const factory SeriesEvent.allSeries() = _AllSeries;
  const factory SeriesEvent.seriesDetail({required String id}) = _SeriesDetail;
}
