import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/auth/models/request/user_payload.dart';
import 'package:golidoli_app/features/auth/models/response/user_model.dart';
import 'package:golidoli_app/features/profile/usecase/update_profile_usecase.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';
part 'edit_profile_bloc.freezed.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final UpdateProfileUsecase _updateProfileUsecase;

  EditProfileBloc({required UpdateProfileUsecase updateProfileUsecase})
      : _updateProfileUsecase = updateProfileUsecase,
        super(const EditProfileState()) {
    on<_Initialize>((event, emit) {
      emit(state.copyWith(
        user: event.user,
        localImageFile: null,
        status: Status.init,
        errorMessage: null,
      ));
    });

    on<_LocalImageChanged>((event, emit) {
      emit(state.copyWith(localImageFile: event.imageFile));
    });

    on<_SaveProfile>((event, emit) async {
      final original = state.user;
      if (original == null) return;

      emit(state.copyWith(status: Status.loading, errorMessage: null));

      try {
        final name = event.name.trim();
        final email = event.email.trim();
        final phone = event.phone.trim();
        final newImagePath = state.localImageFile?.path;

        final payload = UserPayload(
          name: name != original.name ? name : null,
          email: email != original.email ? email : null,
          phone: phone != original.phone ? phone : null,
          interests: null,
          profileImage: newImagePath,
        );

        final result = await _updateProfileUsecase(userPayload: payload);

        if (result != null) {
          emit(state.copyWith(
            user: result,
            status: Status.success,
          ));
        } else {
          emit(state.copyWith(
            status: Status.error,
            errorMessage: "Failed to update profile",
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          status: Status.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}
