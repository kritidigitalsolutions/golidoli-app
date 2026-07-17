import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/movie/models/MovieModel.dart';
import 'package:golidoli_app/features/movie/usecase/all_movie_usecase.dart';

import '../usecase/movie_detail_usecase.dart';

part 'movie_event.dart';
part 'movie_state.dart';
part 'movie_bloc.freezed.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final AllMovieUsecase _allMovieUsecase;
  final MovieDetailUsecase _movieDetailUsecase;
  MovieBloc({
    required AllMovieUsecase allMovieUsecase,
    required MovieDetailUsecase movieDetailUsecase,
  }) : _allMovieUsecase = allMovieUsecase,
       _movieDetailUsecase = movieDetailUsecase,
       super(const MovieState()) {
    on<_AllMovies>((event, emit) async {
      emit(state.copyWith(allMoviesStatus: Status.loading));
      final result = await _allMovieUsecase();
      if (result.isEmpty) {
        emit(state.copyWith(allMoviesStatus: Status.success));
      } else if (result.isNotEmpty) {
        emit(
          state.copyWith(allMovies: result, allMoviesStatus: Status.success),
        );
      } else {
        emit(state.copyWith(allMoviesStatus: Status.error));
      }
    });
    on<_MovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailStatus: Status.loading));
      final result = await _movieDetailUsecase(id: event.value);
      if (result != null) {
        emit(
          state.copyWith(
            movieDetailStatus: Status.success,
            movieDetail: result,
          ),
        );
      } else {
        emit(state.copyWith(movieDetailStatus: Status.error));
      }
    });
  }
}
