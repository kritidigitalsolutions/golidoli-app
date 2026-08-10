import 'package:golidoli_app/features/auth/models/request/user_payload.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/auth/repositories/auth_datasource.dart';

class UpdateProfileUsecase {
  final AuthDatasource authDatasource;

  UpdateProfileUsecase({required this.authDatasource});

  Future<UserModel?> call({required UserPayload userPayload}) async {
    return await authDatasource.updateProfile(userPayload: userPayload);
  }
}
