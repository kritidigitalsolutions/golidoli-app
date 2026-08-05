part of 'micro_drama_bloc.dart';

@freezed
class MicroDramaEvent with _$MicroDramaEvent {
  const factory MicroDramaEvent.allMicroDrama() = _AllMicroDrama;
  const factory MicroDramaEvent.detailMicroDrama({required String id}) = _DetailMicroDrama;
  const factory MicroDramaEvent.episodeDetail({required String id}) = _EpisodeDetail;
}
