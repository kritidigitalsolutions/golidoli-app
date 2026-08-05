part of 'injection.dart';

class InjectionBlock {
  static MovieBloc get movieBloc => MovieBloc(
    allMovieUsecase: getIt<AllMovieUsecase>(),
    movieDetailUsecase: getIt<MovieDetailUsecase>(),
  );
  static SeriesBloc get seriesBloc => SeriesBloc(
    allSeriesUsecase: getIt<AllSeriesUsecase>(),
    seriesDetailUsecase: getIt<SeriesDetailUsecase>(),
  );
  static EpisodeBloc get episodeBloc => EpisodeBloc(
    allEpisodeUsecase: getIt<AllEpisodeUsecase>(),
    detailEpisodeUsecase: getIt<DetailEpisodeUsecase>(),
  );
  static HelpCubit get helpCubit => HelpCubit(
    getHelpUsecase: getIt<GetHelpUsecase>(),
    getDocumentUsecase: getIt<GetDocumentUsecase>(),
    getSingleDocumentUsecase: getIt<SingleDocumentUsecase>(),
  );

  static MicroDramaBloc get microDramaBloc => MicroDramaBloc(
    allMicroDramaUsecase: getIt<AllMicroDramaUsecase>(),
    detailDramaUsecase: getIt<DetailDramaUsecase>(),
    dramaEpisodeDetail: getIt<DramaEpisodeDetail>(),
  );

  static CategoryBloc get categoryBloc => CategoryBloc(
    allCategoriesUsecase: getIt<AllCategoriesUsecase>(),
    categoryDetailUsecase: getIt<CategoryDetailUsecase>(),
  );

  static PlanBloc get planBloc =>
      PlanBloc(allPlanUsecase: getIt<AllPlanUsecase>());

  static ContentBloc get contentBloc =>
      ContentBloc(allContentUsecase: getIt<AllContentUsecase>());
}
