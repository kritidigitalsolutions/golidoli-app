import 'dart:convert';

import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/services/storage_service.dart';
import 'package:golidoli_app/features/micro_drama/models/episode_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:http/http.dart' as http;

class MicroDramaDatasource {
  Future<MicrodramasResponse?> allMicroDrama() async {
    final token = await StorageService.getToken();
    final url = Uri.parse(AppUrl.allMicroDramaApis);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return MicrodramasResponse.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<MicrodramaDetailResponse?> dramaDetail({required String id}) async {
    final url = Uri.parse(AppUrl.singleMicroDrama(id: id));
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return MicrodramaDetailResponse.fromJson(jsonData);
    } else {
      return null;
    }
  }

  Future<EpisodesResponse?> episodeDetail({required String id}) async {
    final url = Uri.parse(AppUrl.microDramaEpisodeDetail(id: id));
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return EpisodesResponse.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
