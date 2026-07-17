import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/repositories/movie_datasource.dart';


class MovieDetailUsecase {
  final MovieDatasource movieDatasource;
  MovieDetailUsecase({required this.movieDatasource});
  Future<MovieModel?>call({required String id})async{
    return await movieDatasource.movieDetail(id: id);
  }
  }
