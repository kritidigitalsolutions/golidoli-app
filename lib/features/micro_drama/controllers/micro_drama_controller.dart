import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_detail_response.dart';
import 'package:golidoli_app/features/micro_drama/usecases/all_micro_drama_usecase.dart';
import 'package:golidoli_app/features/micro_drama/usecases/detail_drama_usecase.dart';
import 'package:golidoli_app/features/micro_drama/usecases/drama_episode_detail.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';

class MicroDramaController extends GetxController {
  final AllMicroDramaUsecase _allMicroDramaUsecase;
  final DetailDramaUsecase _detailDramaUsecase;
  final DramaEpisodeDetail _dramaEpisodeDetail;

  MicroDramaController({
    required AllMicroDramaUsecase allMicroDramaUsecase,
    required DetailDramaUsecase detailDramaUsecase,
    required DramaEpisodeDetail dramaEpisodeDetail,
  })  : _allMicroDramaUsecase = allMicroDramaUsecase,
        _detailDramaUsecase = detailDramaUsecase,
        _dramaEpisodeDetail = dramaEpisodeDetail;

  // ── State ─────────────────────────────────────────────────────────────────
  final allMicroDramaStatus = Status.init.obs;
  final Rx<MicrodramasResponse?> allMicroDrama = Rx(null);

  final detailDramaStatus = Status.init.obs;
  final Rx<MicrodramaDetailResponse?> dramaDetail = Rx(null);

  final episodeDetailStatus = Status.init.obs;
  final Rx<EpisodesResponse?> episodeDetail = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllMicroDrama() async {
    allMicroDramaStatus.value = Status.loading;
    final result = await _allMicroDramaUsecase();
    allMicroDrama.value = result;
    allMicroDramaStatus.value = Status.success;
  }

  Future<void> fetchDramaDetail(String id) async {
    detailDramaStatus.value = Status.loading;
    final result = await _detailDramaUsecase(id: id);
    if (result != null) {
      dramaDetail.value = result;
      detailDramaStatus.value = Status.success;
    } else {
      detailDramaStatus.value = Status.error;
    }
  }

  Future<void> fetchEpisodeDetail(String id) async {
    episodeDetailStatus.value = Status.loading;
    final result = await _dramaEpisodeDetail.call(id: id);
    if (result != null) {
      episodeDetail.value = result;
      episodeDetailStatus.value = Status.success;
    } else {
      episodeDetailStatus.value = Status.error;
    }
  }
}
