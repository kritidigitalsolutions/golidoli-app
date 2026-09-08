import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/micro_drama/datasource/micro_drama_datasource.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/repositories/movie_datasource.dart';
import 'package:golidoli_app/features/web_series/datasource/series_datasource.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';

class WebContentController extends GetxController {
  final MicroDramaDatasource _dramaDatasource = MicroDramaDatasource();
  final MovieDatasource _movieDatasource = MovieDatasource();
  final SeriesDatasource _seriesDatasource = SeriesDatasource();

  // Dramas
  final RxList<Microdrama> dramas = <Microdrama>[].obs;
  final RxBool isDramasLoading = false.obs;
  final RxString selectedDramaGenre = 'All'.obs;

  // Movies
  final RxList<MovieModel> movies = <MovieModel>[].obs;
  final RxBool isMoviesLoading = false.obs;
  final RxString selectedMovieGenre = 'All'.obs;

  // Series
  final RxList<Series> series = <Series>[].obs;
  final RxBool isSeriesLoading = false.obs;
  final RxString selectedSeriesGenre = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDramas();
    fetchMovies();
    fetchSeries();
  }

  Future<void> fetchDramas() async {
    try {
      isDramasLoading.value = true;
      final response = await _dramaDatasource.allMicroDrama(limit: 50);
      if (response != null && response.microdramas.isNotEmpty) {
        dramas.assignAll(response.microdramas);
      }
    } catch (e) {
      debugPrint("WebContentController: fetchDramas error: $e");
    } finally {
      isDramasLoading.value = false;
    }
  }

  Future<void> fetchMovies() async {
    try {
      isMoviesLoading.value = true;
      final response = await _movieDatasource.allMovie(limit: 50);
      if (response.isNotEmpty) {
        movies.assignAll(response);
      }
    } catch (e) {
      debugPrint("WebContentController: fetchMovies error: $e");
    } finally {
      isMoviesLoading.value = false;
    }
  }

  Future<void> fetchSeries() async {
    try {
      isSeriesLoading.value = true;
      final response = await _seriesDatasource.allSeries(limit: 50);
      if (response != null && response.series.isNotEmpty) {
        series.assignAll(response.series);
      }
    } catch (e) {
      debugPrint("WebContentController: fetchSeries error: $e");
    } finally {
      isSeriesLoading.value = false;
    }
  }

  List<String> get dramaGenres {
    final set = <String>{'All'};
    for (var d in dramas) {
      for (var g in d.genre) {
        final str = g.toString().trim();
        if (str.isNotEmpty) {
          if (str.contains(',')) {
            for (var part in str.split(',')) {
              final clean = part.trim();
              if (clean.isNotEmpty) set.add(clean);
            }
          } else {
            set.add(str);
          }
        }
      }
    }
    return set.toList();
  }

  List<String> get movieGenres {
    final set = <String>{'All'};
    for (var m in movies) {
      for (var g in m.genre) {
        final str = g.trim();
        if (str.isNotEmpty) {
          if (str.contains(',')) {
            for (var part in str.split(',')) {
              final clean = part.trim();
              if (clean.isNotEmpty) set.add(clean);
            }
          } else {
            set.add(str);
          }
        }
      }
    }
    return set.toList();
  }

  List<String> get seriesGenres {
    final set = <String>{'All'};
    for (var s in series) {
      for (var g in s.genre) {
        final str = g.trim();
        if (str.isNotEmpty) {
          if (str.contains(',')) {
            for (var part in str.split(',')) {
              final clean = part.trim();
              if (clean.isNotEmpty) set.add(clean);
            }
          } else {
            set.add(str);
          }
        }
      }
    }
    return set.toList();
  }

  List<Microdrama> get filteredDramas {
    final selected = selectedDramaGenre.value.trim().toLowerCase();
    if (selected == 'all' || selected.isEmpty) return dramas;
    return dramas
        .where((d) => d.genre.any((g) {
              final gStr = g.toString().trim().toLowerCase();
              if (gStr == selected) return true;
              if (gStr.contains(',')) {
                return gStr
                    .split(',')
                    .map((e) => e.trim())
                    .contains(selected);
              }
              return gStr.contains(selected);
            }))
        .toList();
  }

  List<MovieModel> get filteredMovies {
    final selected = selectedMovieGenre.value.trim().toLowerCase();
    if (selected == 'all' || selected.isEmpty) return movies;
    return movies
        .where((m) => m.genre.any((g) {
              final gStr = g.trim().toLowerCase();
              if (gStr == selected) return true;
              if (gStr.contains(',')) {
                return gStr
                    .split(',')
                    .map((e) => e.trim())
                    .contains(selected);
              }
              return gStr.contains(selected);
            }))
        .toList();
  }

  List<Series> get filteredSeries {
    final selected = selectedSeriesGenre.value.trim().toLowerCase();
    if (selected == 'all' || selected.isEmpty) return series;
    return series
        .where((s) => s.genre.any((g) {
              final gStr = g.trim().toLowerCase();
              if (gStr == selected) return true;
              if (gStr.contains(',')) {
                return gStr
                    .split(',')
                    .map((e) => e.trim())
                    .contains(selected);
              }
              return gStr.contains(selected);
            }))
        .toList();
  }
}
