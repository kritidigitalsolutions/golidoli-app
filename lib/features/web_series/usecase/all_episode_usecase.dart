import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';

class AllEpisodeUsecase {
  final SeriesDatasource seriesDatasource;
  AllEpisodeUsecase({required this.seriesDatasource});
  Future<EpisodesResponse?>call({required String id})async{
    return await seriesDatasource.allEpisode(id: id);
  }
}