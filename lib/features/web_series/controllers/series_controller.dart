import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';
import 'package:golidoli_app/shared/models/like_dislike_response.dart';

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
  final RxBool isInteracting = false.obs;

  // ── Search & Filter State ──────────────────────────────────────────────────
  final searchStatus = Status.init.obs;
  final RxList<Series> searchedSeries = <Series>[].obs;
  final RxString currentSearchQuery = ''.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isSearchOpen = false.obs;

  final List<String> categories = const [
    'All',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
    'Romance',
    'Thriller',
  ];

  final _api = SeriesDatasource();

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  void openSearch() {
    isSearchOpen.value = true;
  }

  void closeSearch() {
    isSearchOpen.value = false;
    currentSearchQuery.value = '';
    searchedSeries.clear();
    searchStatus.value = Status.init;
  }

  void clearSearch() {
    currentSearchQuery.value = '';
    searchedSeries.clear();
    searchStatus.value = Status.init;
  }

  Future<void> searchSeries(String query) async {
    final q = query.trim();
    currentSearchQuery.value = q;

    if (q.isEmpty) {
      searchStatus.value = Status.init;
      searchedSeries.clear();
      return;
    }

    searchStatus.value = Status.loading;
    try {
      final apiResults = await _api.searchSeries(q);
      if (apiResults.isNotEmpty) {
        searchedSeries.assignAll(apiResults);
        searchStatus.value = Status.success;
        return;
      }
    } catch (_) {}

    // Fallback to local match in loaded series
    final qLower = q.toLowerCase();
    final localList = allSeries.value?.series ?? [];
    final localMatches = localList.where((s) {
      final titleMatch = s.title.toLowerCase().contains(qLower);
      final genreMatch = s.genre.any((g) => g.toLowerCase().contains(qLower));
      final descMatch = s.description.toLowerCase().contains(qLower);
      final langMatch = s.language.toLowerCase().contains(qLower);
      final castMatch =
          s.cast.any((c) => c.toString().toLowerCase().contains(qLower));
      final yearMatch = s.releaseYear.toString().contains(qLower);
      return titleMatch ||
          genreMatch ||
          descMatch ||
          langMatch ||
          castMatch ||
          yearMatch;
    }).toList();

    searchedSeries.assignAll(localMatches);
    searchStatus.value = Status.success;
  }

  List<Series> get filteredSeries {
    final query = currentSearchQuery.value.trim().toLowerCase();
    final selectedCategory = categories[selectedCategoryIndex.value];

    // Combine server search results with local series (deduplicated)
    final Set<String> seenIds = {};
    final List<Series> combinedList = [];

    if (query.isNotEmpty) {
      for (final s in searchedSeries) {
        if (seenIds.add(s.id)) combinedList.add(s);
      }
      final local = allSeries.value?.series ?? [];
      for (final s in local) {
        if (seenIds.add(s.id)) combinedList.add(s);
      }
    } else {
      combinedList.addAll(allSeries.value?.series ?? []);
    }

    return combinedList.where((item) {
      final matchesCategory = selectedCategory == 'All' ||
          item.genre.any(
            (g) => g.toLowerCase() == selectedCategory.toLowerCase(),
          );

      if (!matchesCategory) return false;

      if (query.isEmpty) return true;

      final titleMatch = item.title.toLowerCase().contains(query);
      final genreMatch =
          item.genre.any((g) => g.toLowerCase().contains(query));
      final descMatch = item.description.toLowerCase().contains(query);
      final langMatch = item.language.toLowerCase().contains(query);
      final castMatch =
          item.cast.any((c) => c.toString().toLowerCase().contains(query));
      final yearMatch = item.releaseYear.toString().contains(query);

      return titleMatch ||
          genreMatch ||
          descMatch ||
          langMatch ||
          castMatch ||
          yearMatch;
    }).toList();
  }

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

  Future<LikeDislikeResponse?> toggleLike(String id) async {
    isInteracting.value = true;
    try {
      final res = await _api.toggleLike(id);
      if (res != null && res.success) {
        if (seriesDetail.value != null && seriesDetail.value!.id == id) {
          seriesDetail.value = seriesDetail.value!.copyWith(
            likes: res.totalLikes,
            dislikes: res.totalDislikes,
          );
        }
        if (allSeries.value != null) {
          final list = allSeries.value!.series.map((s) {
            if (s.id == id) {
              return s.copyWith(likes: res.totalLikes, dislikes: res.totalDislikes);
            }
            return s;
          }).toList();
          allSeries.value = allSeries.value!.copyWith(series: list);
        }
      }
      return res;
    } catch (_) {
      return null;
    } finally {
      isInteracting.value = false;
    }
  }

  Future<LikeDislikeResponse?> toggleDislike(String id) async {
    isInteracting.value = true;
    try {
      final res = await _api.toggleDislike(id);
      if (res != null && res.success) {
        if (seriesDetail.value != null && seriesDetail.value!.id == id) {
          seriesDetail.value = seriesDetail.value!.copyWith(
            likes: res.totalLikes,
            dislikes: res.totalDislikes,
          );
        }
        if (allSeries.value != null) {
          final list = allSeries.value!.series.map((s) {
            if (s.id == id) {
              return s.copyWith(likes: res.totalLikes, dislikes: res.totalDislikes);
            }
            return s;
          }).toList();
          allSeries.value = allSeries.value!.copyWith(series: list);
        }
      }
      return res;
    } catch (_) {
      return null;
    } finally {
      isInteracting.value = false;
    }
  }
}

