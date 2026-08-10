import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:golidoli_app/features/profile/usecase/get_document_usecase.dart';
import 'package:golidoli_app/features/profile/usecase/get_help_usecase.dart';
import 'package:golidoli_app/features/profile/usecase/single_document_usecase.dart';

class HelpController extends GetxController {
  final GetHelpUsecase _getHelpUsecase;
  final GetDocumentUsecase _getDocumentUsecase;
  final SingleDocumentUsecase _getSingleDocumentUsecase;

  HelpController({
    required GetHelpUsecase getHelpUsecase,
    required GetDocumentUsecase getDocumentUsecase,
    required SingleDocumentUsecase getSingleDocumentUsecase,
  })  : _getHelpUsecase = getHelpUsecase,
        _getDocumentUsecase = getDocumentUsecase,
        _getSingleDocumentUsecase = getSingleDocumentUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final helpStatus = Status.init.obs;
  final Rx<HelpResponse?> helps = Rx(null);

  final documentStatus = Status.init.obs;
  final Rx<DocumentModel?> documents = Rx(null);

  final singleDocumentStatus = Status.init.obs;
  final Rx<Document?> singleDocument = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllHelp() async {
    helpStatus.value = Status.loading;
    final result = await _getHelpUsecase();
    if (result != null) {
      helps.value = result;
      helpStatus.value = Status.success;
    } else {
      helpStatus.value = Status.error;
    }
  }

  Future<void> fetchDocuments() async {
    documentStatus.value = Status.loading;
    final result = await _getDocumentUsecase();
    if (result != null) {
      documents.value = result;
      documentStatus.value = Status.success;
    } else {
      documentStatus.value = Status.error;
    }
  }

  Future<void> fetchSingleDocument({required String id}) async {
    singleDocumentStatus.value = Status.loading;
    final result = await _getSingleDocumentUsecase(id: id);
    if (result != null) {
      singleDocument.value = result;
      singleDocumentStatus.value = Status.success;
    } else {
      singleDocumentStatus.value = Status.error;
    }
  }
}
