import 'package:get/get.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/usecase/all_movie_usecase.dart';
import 'package:golidoli_app/features/movie/usecase/movie_detail_usecase.dart';

class MovieController extends GetxController {
  final AllMovieUsecase _allMovieUsecase;
  final MovieDetailUsecase _movieDetailUsecase;

  MovieController({
    required AllMovieUsecase allMovieUsecase,
    required MovieDetailUsecase movieDetailUsecase,
  })  : _allMovieUsecase = allMovieUsecase,
        _movieDetailUsecase = movieDetailUsecase;

  // ── State ─────────────────────────────────────────────────────────────────
  final allMoviesStatus = Status.init.obs;
  final RxList<MovieModel> allMovies = <MovieModel>[].obs;

  final movieDetailStatus = Status.init.obs;
  final Rx<MovieModel?> movieDetail = Rx(null);

  // ── Actions ───────────────────────────────────────────────────────────────
  Future<void> fetchAllMovies() async {
    allMoviesStatus.value = Status.loading;
    final result = await _allMovieUsecase();
    if (result.isNotEmpty) {
      allMovies.assignAll(result);
      allMoviesStatus.value = Status.success;
    } else if (result.isEmpty) {
      allMoviesStatus.value = Status.success;
    } else {
      allMoviesStatus.value = Status.error;
    }
  }

  Future<void> fetchMovieDetail(String id) async {
    movieDetailStatus.value = Status.loading;
    final result = await _movieDetailUsecase(id: id);
    if (result != null) {
      movieDetail.value = result;
      movieDetailStatus.value = Status.success;
    } else {
      movieDetailStatus.value = Status.error;
    }
  }
}
