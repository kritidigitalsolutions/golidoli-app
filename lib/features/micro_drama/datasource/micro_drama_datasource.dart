import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/data/network/network_api_service.dart';
import 'package:golidoli_app/features/micro_drama/models/episode_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';

class MicroDramaDatasource {
  final NetworkApiService _apiService = NetworkApiService();

  Future<MicrodramasResponse?> allMicroDrama() async {
    try {
      final json = await _apiService.getApi(AppUrl.allMicroDramaApis);
      if (json != null) {
        return MicrodramasResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<MicrodramaDetailResponse?> dramaDetail({required String id}) async {
    try {
      final json = await _apiService.getApi(AppUrl.singleMicroDrama(id: id));
      if (json != null) {
        return MicrodramaDetailResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<EpisodesResponse?> episodeDetail({required String id}) async {
    try {
      final json = await _apiService.getApi(
        AppUrl.microDramaEpisodeDetail(id: id),
      );
      if (json != null) {
        return EpisodesResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
