part of 'movie_bloc.dart';

@freezed
abstract class MovieState with _$MovieState {
  const factory MovieState({
    @Default([]) List<MovieModel> allMovies,
    @Default(null) MovieModel? movieDetail,
    @Default(Status.init) Status allMoviesStatus,
    @Default(Status.init) Status movieDetailStatus,
  }) = _MovieState;
}
