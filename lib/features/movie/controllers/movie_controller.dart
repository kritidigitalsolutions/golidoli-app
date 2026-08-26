import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/repositories/movie_datasource.dart';

class MovieController extends GetxController {
  // final AllMovieUsecase _allMovieUsecase;
  // final MovieDetailUsecase _movieDetailUsecase;

  // MovieController({
  //   required AllMovieUsecase allMovieUsecase,
  //   required MovieDetailUsecase movieDetailUsecase,
  // })  : _allMovieUsecase = allMovieUsecase,
  //       _movieDetailUsecase = movieDetailUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final allMoviesStatus = Status.init.obs;
  final RxList<MovieModel> allMovies = <MovieModel>[].obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  static const int pageSize = 12;

  final movieDetailStatus = Status.init.obs;
  final Rx<MovieModel?> movieDetail = Rx(null);

  final MovieDatasource _api = MovieDatasource();

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllMovies() async {
    currentPage = 1;
    hasMore.value = true;
    allMoviesStatus.value = Status.loading;
    try {
      final result = await _api.allMovie(page: 1, limit: pageSize);
      allMovies.assignAll(result);
      if (result.length < pageSize) {
        hasMore.value = false;
      }
      allMoviesStatus.value = Status.success;
    } catch (_) {
      allMoviesStatus.value = Status.error;
    }
  }

  Future<void> fetchMoreMovies() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = currentPage + 1;
      final result = await _api.allMovie(page: nextPage, limit: pageSize);
      if (result.isNotEmpty) {
        // Filter out any duplicates
        final existingIds = allMovies.map((m) => m.id).toSet();
        final newItems = result.where((m) => !existingIds.contains(m.id)).toList();
        if (newItems.isNotEmpty) {
          allMovies.addAll(newItems);
          currentPage = nextPage;
        } else {
          hasMore.value = false;
        }
        if (result.length < pageSize) {
          hasMore.value = false;
        }
      } else {
        hasMore.value = false;
      }
    } catch (_) {
      // Don't mark fatal error on paginate, just stop
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchMovieDetail(String id) async {
    movieDetailStatus.value = Status.loading;
    final result = await _api.movieDetail(id: id);
    if (result != null) {
      movieDetail.value = result;
      movieDetailStatus.value = Status.success;
    } else {
      movieDetailStatus.value = Status.error;
    }
  }
}
