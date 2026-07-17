part of 'movie_bloc.dart';

@freezed
class MovieEvent with _$MovieEvent {
  const factory MovieEvent.allMovies() = _AllMovies;
  const factory MovieEvent.movieDetail({required String value}) = _MovieDetail;
}
