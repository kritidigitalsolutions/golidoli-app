import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

class SingleDocumentUsecase {
  final ProfileDatasource datasource;

  SingleDocumentUsecase({required this.datasource});

  Future<Document?> call({required String id}) async {
    return await datasource.getSingleDocument(id: id);
  }
}