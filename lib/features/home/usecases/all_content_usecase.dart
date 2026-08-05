import 'package:golidoli_app/features/home/models/content_model.dart';
import 'package:golidoli_app/features/home/repositories/home_datasource.dart';

class AllContentUsecase {
  final HomeDatasource homeDatasource;
  AllContentUsecase({required this.homeDatasource});
  Future<HomeContentResponse?>call()async{
    return await homeDatasource.allContent();
  }
}