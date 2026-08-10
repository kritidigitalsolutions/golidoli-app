import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/model/episode_response.dart';
import 'package:golidoli_app/features/web_series/model/episode_model.dart';
import 'package:golidoli_app/features/web_series/usecase/all_episode_usecase.dart';
import 'package:golidoli_app/features/web_series/usecase/detail_episode_usecase.dart';

class EpisodeController extends GetxController {
  final AllEpisodeUsecase _allEpisodeUsecase;
  final DetailEpisodeUsecase _detailEpisodeUsecase;

  EpisodeController({
    required AllEpisodeUsecase allEpisodeUsecase,
    required DetailEpisodeUsecase detailEpisodeUsecase,
  })  : _allEpisodeUsecase = allEpisodeUsecase,
        _detailEpisodeUsecase = detailEpisodeUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final allEpisodeStatus = Status.init.obs;
  final Rx<EpisodesResponse?> allEpisode = Rx(null);

  final detailEpisodeStatus = Status.init.obs;
  final Rx<EpisodeModel?> episodeDetail = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllEpisodes(String id) async {
    allEpisodeStatus.value = Status.loading;
    final result = await _allEpisodeUsecase(id: id);
    if (result != null) {
      allEpisode.value = result;
      allEpisodeStatus.value = Status.success;
    } else {
      allEpisodeStatus.value = Status.error;
    }
  }

  Future<void> fetchEpisodeDetail(String id) async {
    detailEpisodeStatus.value = Status.loading;
    final result = await _detailEpisodeUsecase(id: id);
    if (result != null) {
      episodeDetail.value = result;
      detailEpisodeStatus.value = Status.success;
    } else {
      detailEpisodeStatus.value = Status.error;
    }
  }
}
