import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/datasource/micro_drama_datasource.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/models/episode_detail_response.dart';

class MicroDramaController extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final allMicroDramaStatus = Status.init.obs;
  final Rx<MicrodramasResponse?> allMicroDrama = Rx(null);

  final detailDramaStatus = Status.init.obs;
  final Rx<MicrodramaDetailResponse?> dramaDetail = Rx(null);

  final episodeDetailStatus = Status.init.obs;
  final Rx<MicroDramaEpisodesResponse?> episodeDetail = Rx(null);

  final _api = MicroDramaDatasource();

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllMicroDrama() async {
    allMicroDramaStatus.value = Status.loading;
    final result = await _api.allMicroDrama();
    allMicroDrama.value = result;
    allMicroDramaStatus.value = Status.success;
  }

  Future<void> fetchDramaDetail(String id) async {
    detailDramaStatus.value = Status.loading;
    final result = await _api.dramaDetail(id: id);
    if (result != null) {
      dramaDetail.value = result;
      detailDramaStatus.value = Status.success;
    } else {
      detailDramaStatus.value = Status.error;
    }
  }

  Future<void> fetchEpisodeDetail(String id) async {
    episodeDetailStatus.value = Status.loading;
    final result = await _api.episodeDetail(id: id);
    if (result != null) {
      episodeDetail.value = result;
      episodeDetailStatus.value = Status.success;
    } else {
      episodeDetailStatus.value = Status.error;
    }
  }
}
