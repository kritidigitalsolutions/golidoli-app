import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';

class SeriesController extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final allSeriesStatus = Status.init.obs;
  final Rx<SeriesResponse?> allSeries = Rx(null);

  final seriesDetailStatus = Status.init.obs;
  final Rx<Series?> seriesDetail = Rx(null);

  final _api = SeriesDatasource();

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllSeries() async {
    allSeriesStatus.value = Status.loading;
    final result = await _api.allSeries();
    if (result != null) {
      allSeries.value = result;
      allSeriesStatus.value = Status.success;
    } else {
      allSeriesStatus.value = Status.error;
    }
  }

  Future<void> fetchSeriesDetail(String id) async {
    seriesDetailStatus.value = Status.loading;
    final result = await _api.seriesDetail(id: id);
    if (result != null) {
      seriesDetail.value = result;
      seriesDetailStatus.value = Status.success;
    } else {
      seriesDetailStatus.value = Status.error;
    }
  }
}
