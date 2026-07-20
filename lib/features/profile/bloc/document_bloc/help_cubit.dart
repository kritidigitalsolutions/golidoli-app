import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:golidoli_app/features/profile/usecase/get_document_usecase.dart';
import 'package:golidoli_app/features/profile/usecase/single_document_usecase.dart';

import '../../usecase/get_help_usecase.dart';

part 'help_state.dart';
part 'help_cubit.freezed.dart';

class HelpCubit extends Cubit<HelpState> {
  final GetHelpUsecase _getHelpUsecase;
  final GetDocumentUsecase _getDocumentUsecase;
  final SingleDocumentUsecase _getSingleDocumentUsecase;
  HelpCubit({
    required GetHelpUsecase getHelpUsecase,
    required GetDocumentUsecase getDocumentUsecase,
    required SingleDocumentUsecase getSingleDocumentUsecase,
  }) : _getHelpUsecase = getHelpUsecase,
       _getDocumentUsecase = getDocumentUsecase,
       _getSingleDocumentUsecase = getSingleDocumentUsecase,
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
  void singleDocument({required String id})async{
    emit(state.copyWith(singleDocumentStatus: Status.loading));
    final result = await _getSingleDocumentUsecase(id: id);
    if(result != null){
      emit(state.copyWith(singleDocumentStatus: Status.success, singleDocument: result));
    }else{
      emit(state.copyWith(singleDocumentStatus: Status.error));
    }
  }
}
