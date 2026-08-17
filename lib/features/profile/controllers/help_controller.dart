import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/profile/models/response/DocumentModel.dart';
import 'package:golidoli_app/features/profile/models/response/help_response.dart';
import 'package:golidoli_app/features/profile/repositories/profile_datasource.dart';

class HelpController extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final helpStatus = Status.init.obs;
  final Rx<HelpResponse?> helps = Rx(null);

  final documentStatus = Status.init.obs;
  final Rx<DocumentModel?> documents = Rx(null);

  final singleDocumentStatus = Status.init.obs;
  final Rx<Document?> singleDocument = Rx(null);

  final ProfileDatasource _api = ProfileDatasource();

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllHelp() async {
    helpStatus.value = Status.loading;
    final result = await _api.allHelp();
    if (result != null) {
      helps.value = result;
      helpStatus.value = Status.success;
    } else {
      helpStatus.value = Status.error;
    }
  }

  Future<void> fetchDocuments() async {
    documentStatus.value = Status.loading;
    final result = await _api.getDocument();
    if (result != null) {
      documents.value = result;
      documentStatus.value = Status.success;
    } else {
      documentStatus.value = Status.error;
    }
  }

  Future<void> fetchSingleDocument({required String id}) async {
    singleDocumentStatus.value = Status.loading;
    final result = await _api.getSingleDocument(id: id);
    if (result != null) {
      singleDocument.value = result;
      singleDocumentStatus.value = Status.success;
    } else {
      singleDocumentStatus.value = Status.error;
    }
  }
}
