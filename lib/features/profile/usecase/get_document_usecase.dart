import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

class GetDocumentUsecase {
  final ProfileDatasource profileDatasource;
  GetDocumentUsecase({required this.profileDatasource});
  Future<DocumentModel?>call()async{
    return await profileDatasource.getDocument();
  }
}