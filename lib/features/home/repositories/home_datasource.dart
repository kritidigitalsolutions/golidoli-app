import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/core/data/network/network_api_service.dart';
import '../models/category_model.dart';
import '../models/category_detail_model.dart';
import '../models/content_model.dart';

class HomeDatasource {
  final NetworkApiService _apiService;

  HomeDatasource(this._apiService);

  Future<CategoriesResponse?> allCategories() async {
    try {
      final json = await _apiService.getApi(AppUrl.allCategories);
      if (json != null) {
        return CategoriesResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<CategoryContentResponse?> categoryDetail({
    required String id,
    required int page,
    required int size,
  }) async {
    try {
      final json = await _apiService.getApi(
        AppUrl.categoryDetail(id: id, page: page, size: size),
      );
      if (json != null) {
        return CategoryContentResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<HomeContentResponse?> allContent() async {
    try {
      final json = await _apiService.getApi(AppUrl.allContentApi);
      if (json != null) {
        return HomeContentResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<HomeContentResponse?> searchContent(String query) async {
    try {
      final json = await _apiService.getApi(AppUrl.searchContent(query: query));
      if (json != null) {
        return HomeContentResponse.fromJson(json);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
