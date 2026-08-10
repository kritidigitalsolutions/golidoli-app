import 'package:golidoli_app/features/micro_drama/datasource/micro_drama_datasource.dart';

import '../../web_series/model/episode_response.dart';

class DramaEpisodeDetail {
  final MicroDramaDatasource microDramaDatasource;
  DramaEpisodeDetail({required this.microDramaDatasource});
  Future<EpisodesResponse?> call({required String id}) async {
    await microDramaDatasource.episodeDetail(id: id);
    return null;
  }
}
