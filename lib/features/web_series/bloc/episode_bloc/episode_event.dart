part of 'episode_bloc.dart';

@freezed
abstract class EpisodeEvent with _$EpisodeEvent {
  const factory EpisodeEvent.allEpisode({required String id}) = _AllEpisode;
  const factory EpisodeEvent.episodeDetail({required String id}) = _EpisodeDetail;
}
