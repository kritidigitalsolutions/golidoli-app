import 'dart:convert';

import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/features/web_series/model/episode_model.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';
import 'package:http/http.dart' as http;

class SeriesDatasource {
  Future<SeriesResponse?> allSeries() async {
    final url = Uri.parse(AppUrl.allSeries);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return SeriesResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load series. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching series: $e');
    }
  }

  Future<Series?> seriesDetail({required String id}) async {
    final url = Uri.parse(AppUrl.seriesDetail(id));

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // If API returns: { "success": true, "series": { ... } }
        return Series.fromJson(jsonData['series']);

        // If API returns the series object directly, use:
        // return Series.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load series details. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching series details: $e');
    }
  }

  Future<EpisodesResponse?> allEpisode({required String id}) async {
    try {
      final token = await StorageService.getToken();

      final url = Uri.parse(AppUrl.episodes(id));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        return EpisodesResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load episodes. Status Code: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching episodes: $e');
    }
  }

  Future<EpisodeModel?> singleEpisode({required String id}) async {
    try {
      final token = await StorageService.getToken();

      final url = Uri.parse(AppUrl.singleEpisode(id: id));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return EpisodeModel.fromJson(jsonData);
      } else {
        print('Failed to fetch episode');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in singleEpisode(): $e');
      return null;
    }
  }
}
