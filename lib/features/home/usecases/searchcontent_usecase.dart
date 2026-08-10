import 'package:golidoli_app/features/home/models/content_model.dart';
import 'package:golidoli_app/features/home/repositories/home_datasource.dart';

class SearchcontentUsecase {
  final HomeDatasource homeDatasource;
  SearchcontentUsecase({required this.homeDatasource});

  Future<HomeContentResponse?> call(String query) async {
    return await homeDatasource.searchContent(query);
  }
}
