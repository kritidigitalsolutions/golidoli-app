part of 'edit_profile_bloc.dart';

@freezed
class EditProfileEvent with _$EditProfileEvent {
  const factory EditProfileEvent.initialize({required UserModel user}) = _Initialize;
  const factory EditProfileEvent.localImageChanged({required File imageFile}) = _LocalImageChanged;
  const factory EditProfileEvent.saveProfile({
    required String name,
    required String email,
    required String phone,
  }) = _SaveProfile;
}