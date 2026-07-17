import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/episode_model.dart';

class DetailEpisodeUsecase {
  final SeriesDatasource seriesDatasource;
  DetailEpisodeUsecase({required this.seriesDatasource});
  Future<EpisodeModel?>call({required String id})async{
    return await seriesDatasource.singleEpisode(id: id);
  }
}