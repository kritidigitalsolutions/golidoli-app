import 'dart:convert' as convert;

import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:http/http.dart' as http;

class MovieDatasource {
  Future<List<MovieModel>> allMovie() async {
    try {
      final url = Uri.parse(AppUrl.allMovies);

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = convert.jsonDecode(response.body);

        final List<dynamic> moviesJson = jsonData['movies'] ?? [];

        return moviesJson
            .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception(
        'Failed to load movies. Status Code: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  Future<MovieModel?> movieDetail({required String id}) async {
    try {
      final url = Uri.parse(AppUrl.detailMovie(id));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = convert.jsonDecode(response.body);

        return MovieModel.fromJson(jsonData['movie']);
      }

      throw Exception(
        'Failed to load movie details. Status Code: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }
}
