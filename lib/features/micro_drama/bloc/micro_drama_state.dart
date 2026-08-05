part of 'micro_drama_bloc.dart';

@freezed
abstract class MicroDramaState with _$MicroDramaState {
  const factory MicroDramaState({
    @Default(Status.init) Status allMicroDramaStatus,
    @Default(null) MicrodramasResponse? allMicroDrama,
    @Default(null) MicrodramaDetailResponse? dramaDetail,
    @Default(Status.init)Status detailDramaStatus,
    @Default(Status.init)Status episodeDetailStatus,
    @Default(null) EpisodesResponse? episodeDetail,
  }) = _MicroDramaState;
}
