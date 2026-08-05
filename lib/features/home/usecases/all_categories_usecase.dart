import 'package:golidoli_app/features/home/models/category_model.dart';
import 'package:golidoli_app/features/home/repositories/home_datasource.dart';

class AllCategoriesUsecase {
  final HomeDatasource homeDatasource;
  AllCategoriesUsecase({required this.homeDatasource});
  Future<CategoriesResponse?> call() async {
    return await homeDatasource.allCategories();
  }
}
