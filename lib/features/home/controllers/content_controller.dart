import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/home/models/content_model.dart';
import 'package:golidoli_app/features/home/usecases/all_content_usecase.dart';
import 'package:golidoli_app/features/home/usecases/searchcontent_usecase.dart';

class ContentController extends GetxController {
  final AllContentUsecase _allContentUsecase;
  final SearchcontentUsecase _searchContentUsecase;

  ContentController({
    required AllContentUsecase allContentUsecase,
    required SearchcontentUsecase searchContentUsecase,
  })  : _allContentUsecase = allContentUsecase,
        _searchContentUsecase = searchContentUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final allContentStatus = Status.init.obs;
  final Rx<HomeContentResponse?> allContents = Rx(null);

  final searchContentStatus = Status.init.obs;
  final Rx<HomeContentResponse?> searchContents = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllContent() async {
    allContentStatus.value = Status.loading;
    final result = await _allContentUsecase();
    if (result != null) {
      allContents.value = result;
      allContentStatus.value = Status.success;
    } else {
      allContentStatus.value = Status.error;
    }
  }

  Future<void> searchContent(String query) async {
    if (query.trim().isEmpty) {
      searchContentStatus.value = Status.init;
      searchContents.value = null;
      return;
    }
    searchContentStatus.value = Status.loading;
    final result = await _searchContentUsecase(query.trim());
    if (result != null) {
      searchContents.value = result;
      searchContentStatus.value = Status.success;
    } else {
      searchContentStatus.value = Status.error;
    }
  }
}
