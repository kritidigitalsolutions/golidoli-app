import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:golidoli_app/features/profile/usecase/get_document_usecase.dart';

import '../../usecase/get_help_usecase.dart';

part 'help_state.dart';
part 'help_cubit.freezed.dart';

class HelpCubit extends Cubit<HelpState> {
  final GetHelpUsecase _getHelpUsecase;
  final GetDocumentUsecase _getDocumentUsecase;
  HelpCubit({
    required GetHelpUsecase getHelpUsecase,
    required GetDocumentUsecase getDocumentUsecase,
  }) : _getHelpUsecase = getHelpUsecase,
       _getDocumentUsecase = getDocumentUsecase,
       super(HelpState());
  void allHelp() async {
    emit(state.copyWith(helpStatus: Status.loading));
    final result = await _getHelpUsecase();
    if (result != null) {
      emit(state.copyWith(helpStatus: Status.success, helps: result));
    } else {
      emit(state.copyWith(helpStatus: Status.error));
    }
  }

  Future<void> getDocuments() async {
    emit(state.copyWith(documentStatus: Status.loading));

    final result = await _getDocumentUsecase();

    if (result != null) {
      emit(
        state.copyWith(documentStatus: Status.success, documents: result),
      );
    } else {
      emit(state.copyWith(documentStatus: Status.error));
    }
  }
}
