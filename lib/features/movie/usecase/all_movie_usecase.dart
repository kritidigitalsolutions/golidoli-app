import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/repositories/movie_datasource.dart';

class AllMovieUsecase {
  final MovieDatasource movieDatasource;
  AllMovieUsecase({required this.movieDatasource});
  Future<List<MovieModel>>call()async{
    return await movieDatasource.allMovie();
  }
}