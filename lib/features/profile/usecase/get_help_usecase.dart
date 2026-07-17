import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

class GetHelpUsecase {
  final ProfileDatasource profileDatasource;
  GetHelpUsecase({required this.profileDatasource});
  Future<HelpResponse?>call()async{
    return await profileDatasource.allHelp();
  }
}