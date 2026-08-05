import 'package:golidoli_app/features/micro_drama/datasource/micro_drama_datasource.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_detail_response.dart';

class DetailDramaUsecase {
  final MicroDramaDatasource microDramaDatasource;
  DetailDramaUsecase({required this.microDramaDatasource});
  Future<MicrodramaDetailResponse?> call({required String id}) async {
    return await microDramaDatasource.dramaDetail(id: id);
  }
}
