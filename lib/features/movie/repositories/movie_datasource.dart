import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/data/network/network_api_service.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';

class MovieDatasource {
  final NetworkApiService _apiService = NetworkApiService();

  Future<List<MovieModel>> allMovie() async {
    try {
      final jsonData = await _apiService.getApi(AppUrl.allMovies);
      final List<dynamic> moviesJson = jsonData['movies'] ?? [];
      return moviesJson
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieModel?> movieDetail({required String id}) async {
    try {
      final jsonData = await _apiService.getApi(AppUrl.detailMovie(id));
      return MovieModel.fromJson(jsonData['movie']);
    } catch (e) {
      rethrow;
    }
  }
}
