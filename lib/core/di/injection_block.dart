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

      
}
