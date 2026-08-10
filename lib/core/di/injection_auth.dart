part of 'injection.dart';

Future<void> _authDependency() async {
  // AUTH DATASOURCE
  final authDatasource = AuthDatasource();
  getIt.registerLazySingleton<AuthDatasource>(() => authDatasource);

  //MOVIE DATASOURCE

  final movieDatasource = MovieDatasource();
  getIt.registerLazySingleton<MovieDatasource>(() => movieDatasource);

  //MICRO DRAMA DATASOURCE

  final microDramaDatasource = MicroDramaDatasource();
  getIt.registerLazySingleton<MicroDramaDatasource>(() => microDramaDatasource);

  //Home Datasource

  final homeDatasource = HomeDatasource();
  getIt.registerLazySingleton<HomeDatasource>(() => homeDatasource);

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

  //ALL MICRO DRAMA
  final allMicroDramaUsecase = AllMicroDramaUsecase(
    microDramaDatasource: getIt<MicroDramaDatasource>(),
  );
  getIt.registerLazySingleton<AllMicroDramaUsecase>(() => allMicroDramaUsecase);

  //MICRO DRAMA DETAIL
  final detailMicroDramaUsecase = DetailDramaUsecase(
    microDramaDatasource: getIt<MicroDramaDatasource>(),
  );
  getIt.registerLazySingleton<DetailDramaUsecase>(
    () => detailMicroDramaUsecase,
  );

  //MICRO DRAMA EPISODE DETAIL
  final dramaEpisodeDetail = DramaEpisodeDetail(
    microDramaDatasource: getIt<MicroDramaDatasource>(),
  );
  getIt.registerLazySingleton<DramaEpisodeDetail>(() => dramaEpisodeDetail);

  //ALL CATEGORIES
  final allCategoriesUsecase = AllCategoriesUsecase(
    homeDatasource: getIt<HomeDatasource>(),
  );
  getIt.registerLazySingleton<AllCategoriesUsecase>(() => allCategoriesUsecase);

  //DEATIL CATEGORY

  final categoryDetailUsecase = CategoryDetailUsecase(
    homeDatasource: getIt<HomeDatasource>(),
  );
  getIt.registerLazySingleton<CategoryDetailUsecase>(
    () => categoryDetailUsecase,
  );

  //ALL PLAN
  final allPlanUsecase = AllPlanUsecase(
    profileDatasource: getIt<ProfileDatasource>(),
  );
  getIt.registerLazySingleton<AllPlanUsecase>(() => allPlanUsecase);

  //ALL CONTENT
  final allContentUsecase = AllContentUsecase(
    homeDatasource: getIt<HomeDatasource>(),
  );
  getIt.registerLazySingleton<AllContentUsecase>(() => allContentUsecase);

  // UPDATE PROFILE USECASE
  final updateProfileUsecase = UpdateProfileUsecase(
    authDatasource: getIt<AuthDatasource>(),
  );
  getIt.registerLazySingleton<UpdateProfileUsecase>(() => updateProfileUsecase);

  // Search Content USECASE
  final searchontentUsecase = SearchcontentUsecase(
    homeDatasource: getIt<HomeDatasource>(),
  );
  getIt.registerLazySingleton<SearchcontentUsecase>(() => searchontentUsecase);
}
