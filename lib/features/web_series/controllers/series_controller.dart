import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';

class SeriesController extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final allSeriesStatus = Status.init.obs;
  final Rx<SeriesResponse?> allSeries = Rx(null);
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  static const int pageSize = 12;

  final seriesDetailStatus = Status.init.obs;
  final Rx<Series?> seriesDetail = Rx(null);

  final _api = SeriesDatasource();

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllSeries() async {
    currentPage = 1;
    hasMore.value = true;
    allSeriesStatus.value = Status.loading;
    final result = await _api.allSeries(page: 1, limit: pageSize);
    if (result != null) {
      allSeries.value = result;
      if (result.series.length < pageSize) {
        hasMore.value = false;
      }
      allSeriesStatus.value = Status.success;
    } else {
      allSeriesStatus.value = Status.error;
    }
  }

  Future<void> fetchMoreSeries() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = currentPage + 1;
      final result = await _api.allSeries(page: nextPage, limit: pageSize);
      if (result != null && result.series.isNotEmpty) {
        final current = allSeries.value;
        if (current != null) {
          final existingIds = current.series.map((s) => s.id).toSet();
          final newSeries = result.series.where((s) => !existingIds.contains(s.id)).toList();
          if (newSeries.isNotEmpty) {
            final combined = List<Series>.from(current.series)..addAll(newSeries);
            allSeries.value = current.copyWith(series: combined);
            currentPage = nextPage;
          } else {
            hasMore.value = false;
          }
          if (result.series.length < pageSize) {
            hasMore.value = false;
          }
        }
      } else {
        hasMore.value = false;
      }
    } catch (_) {
    } finally {
      isLoadingMore.value = false;
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
