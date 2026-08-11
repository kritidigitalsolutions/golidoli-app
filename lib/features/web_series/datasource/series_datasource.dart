import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/data/network/network_api_service.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/features/web_series/model/episode_model.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';

class SeriesDatasource {
  final NetworkApiService _apiService;

  SeriesDatasource(this._apiService);

  Future<SeriesResponse?> allSeries() async {
    try {
      final json = await _apiService.getApi(AppUrl.allSeries);
      if (json != null) {
        return SeriesResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Series?> seriesDetail({required String id}) async {
    try {
      final json = await _apiService.getApi(AppUrl.seriesDetail(id));
      if (json != null) {
        return Series.fromJson(json['series']);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<EpisodesResponse?> allEpisode({required String id}) async {
    try {
      final json = await _apiService.getApi(AppUrl.episodes(id));
      if (json != null) {
        return EpisodesResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<EpisodeModel?> singleEpisode({required String id}) async {
    try {
      final json = await _apiService.getApi(AppUrl.singleEpisode(id: id));
      if (json != null) {
        return EpisodeModel.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
