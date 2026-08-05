import 'package:golidoli_app/features/home/models/category_detail_model.dart';
import 'package:golidoli_app/features/home/repositories/home_datasource.dart';

class CategoryDetailUsecase {
  final HomeDatasource homeDatasource;
  CategoryDetailUsecase({required this.homeDatasource});
  Future<CategoryContentResponse?>call({required String id,required int page,required int size})async{
    return await homeDatasource.categoryDetail(id: id, page: page, size: size);
  }
}