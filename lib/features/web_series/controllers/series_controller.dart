import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/features/web_series/usecase/all_series_usecase.dart';
import 'package:golidoli_app/features/web_series/usecase/series_detail_usecase.dart';

class SeriesController extends GetxController {
  final AllSeriesUsecase _allSeriesUsecase;
  final SeriesDetailUsecase _seriesDetailUsecase;

  SeriesController({
    required AllSeriesUsecase allSeriesUsecase,
    required SeriesDetailUsecase seriesDetailUsecase,
  })  : _allSeriesUsecase = allSeriesUsecase,
        _seriesDetailUsecase = seriesDetailUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final allSeriesStatus = Status.init.obs;
  final Rx<SeriesResponse?> allSeries = Rx(null);

  final seriesDetailStatus = Status.init.obs;
  final Rx<Series?> seriesDetail = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllSeries() async {
    allSeriesStatus.value = Status.loading;
    final result = await _allSeriesUsecase();
    if (result != null) {
      allSeries.value = result;
      allSeriesStatus.value = Status.success;
    } else {
      allSeriesStatus.value = Status.error;
    }
  }

  Future<void> fetchSeriesDetail(String id) async {
    seriesDetailStatus.value = Status.loading;
    final result = await _seriesDetailUsecase(id: id);
    if (result != null) {
      seriesDetail.value = result;
      seriesDetailStatus.value = Status.success;
    } else {
      seriesDetailStatus.value = Status.error;
    }
  }
}
