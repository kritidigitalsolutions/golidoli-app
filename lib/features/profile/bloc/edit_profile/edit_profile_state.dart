part of 'edit_profile_bloc.dart';

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    UserModel? user,
    File? localImageFile,
    @Default(Status.init) Status status,
    String? errorMessage,
  }) = _EditProfileState;
}
