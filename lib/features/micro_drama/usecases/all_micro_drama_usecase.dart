import 'package:golidoli_app/features/micro_drama/datasource/micro_drama_datasource.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';

class AllMicroDramaUsecase {
  final MicroDramaDatasource microDramaDatasource;
  AllMicroDramaUsecase({required this.microDramaDatasource});
  Future<MicrodramasResponse?>call()async{
    return await microDramaDatasource.allMicroDrama();
  }
}