part of 'injection.dart';

Future<void> _authDependency() async {
  //MOVIE DATASOURCE

  final movieDatasource = MovieDatasource();
  getIt.registerLazySingleton<MovieDatasource>(() => movieDatasource);

  //SERIES DATASOURCE

  final seriesDatasource = SeriesDatasource();
  getIt.registerLazySingleton<SeriesDatasource>(() => seriesDatasource);

  //PROFILE DATASOURCE

  final profileDatasource = ProfileDatasource();
  getIt.registerLazySingleton<ProfileDatasource>(() => profileDatasource);

  //All MOVIE USECASE

  final allMovieUsecase = AllMovieUsecase(
    movieDatasource: getIt<MovieDatasource>(),
  );
  getIt.registerLazySingleton<AllMovieUsecase>(() => allMovieUsecase);

  //MovieDetail Usecase

  final movieDetailUsecase = MovieDetailUsecase(
    movieDatasource: getIt<MovieDatasource>(),
  );
  getIt.registerLazySingleton<MovieDetailUsecase>(() => movieDetailUsecase);

  //ALL SERIES

  final allSeriesUsecase = AllSeriesUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<AllSeriesUsecase>(() => allSeriesUsecase);

  //SERIES DETAIL
  final seriesDetailUsecase = SeriesDetailUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<SeriesDetailUsecase>(() => seriesDetailUsecase);

  //All EPISODE
  final allEpisodeUsecase = AllEpisodeUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<AllEpisodeUsecase>(() => allEpisodeUsecase);

  //Get Help Usecase
  final getHelpUsecase = GetHelpUsecase(
    profileDatasource: getIt<ProfileDatasource>(),
  );
  getIt.registerLazySingleton<GetHelpUsecase>(() => getHelpUsecase);

  //Detail Episode Usecase
  final detailEpisodeUsecase = DetailEpisodeUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<DetailEpisodeUsecase>(() => detailEpisodeUsecase);

  //Get Document Usecase
  final getDocumentUsecase = GetDocumentUsecase(
    profileDatasource: getIt<ProfileDatasource>(),
  );
  getIt.registerLazySingleton<GetDocumentUsecase>(() => getDocumentUsecase);

  //Get Single Document Usecase
  final getSingleDocumentUsecase = SingleDocumentUsecase(
    datasource: getIt<ProfileDatasource>(),
  );
  getIt.registerLazySingleton<SingleDocumentUsecase>(
    () => getSingleDocumentUsecase,
  );
}
