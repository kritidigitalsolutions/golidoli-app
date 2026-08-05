import 'dart:convert';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/home/models/content_model.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/category_detail_model.dart';

class HomeDatasource {
  Future<CategoriesResponse?> allCategories() async {
    final url = Uri.parse(AppUrl.allCategories);
    final response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      // ✅ Decode the JSON body to a Map
      final Map<String, dynamic> json = jsonDecode(response.body);
      return CategoriesResponse.fromJson(json);
    } else {
      return null;
    }
  }

  Future<CategoryContentResponse?> categoryDetail({
    required String id,
    required int page,
    required int size,
  }) async {
    final url = Uri.parse(
      AppUrl.categoryDetail(id: id, page: page, size: size),
    );
    final response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return CategoryContentResponse.fromJson(json);
    } else {
      return null;
    }
  }

  Future<HomeContentResponse?> allContent() async {
    final url = Uri.parse(AppUrl.allContentApi);
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return HomeContentResponse.fromJson(json);
    } else {
      return null;
    }
  }
}
