part of 'episode_bloc.dart';

@freezed
abstract class EpisodeState with _$EpisodeState {
  const factory EpisodeState({
    @Default(null) EpisodesResponse? allEpisode,
    @Default(Status.init) Status allEpisodeStatus,
    @Default(Status.init)Status detailEpisode,
    @Default(null) EpisodeModel? episodeDetail,
  }) = _EpisodeState;
}
