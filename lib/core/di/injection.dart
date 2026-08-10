import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:golidoli_app/features/home/controllers/category_controller.dart';
import 'package:golidoli_app/features/home/controllers/content_controller.dart';
import 'package:golidoli_app/features/home/usecases/searchcontent_usecase.dart';
import 'package:golidoli_app/features/micro_drama/controllers/micro_drama_controller.dart';
import 'package:golidoli_app/features/movie/controllers/movie_controller.dart';
import 'package:golidoli_app/features/movie/repositories/movie_datasource.dart';
import 'package:golidoli_app/features/movie/usecase/all_movie_usecase.dart';
import 'package:golidoli_app/features/movie/usecase/movie_detail_usecase.dart';
import 'package:golidoli_app/features/profile/controllers/edit_profile_controller.dart';
import 'package:golidoli_app/features/profile/controllers/help_controller.dart';
import 'package:golidoli_app/features/profile/controllers/plan_controller.dart';
import 'package:golidoli_app/features/profile/usecase/single_document_usecase.dart';
import 'package:golidoli_app/features/web_series/controllers/episode_controller.dart';
import 'package:golidoli_app/features/web_series/controllers/series_controller.dart';
import 'package:golidoli_app/features/web_series/usecase/all_episode_usecase.dart';

import '../../features/home/repositories/home_datasource.dart';
import '../../features/home/usecases/all_categories_usecase.dart';
import '../../features/home/usecases/all_content_usecase.dart';
import '../../features/home/usecases/category_detail_usecase.dart';
import '../../features/home/usecases/searchcontent_usecase.dart';
import '../../features/micro_drama/datasource/micro_drama_datasource.dart';
import '../../features/micro_drama/usecases/all_micro_drama_usecase.dart';
import '../../features/micro_drama/usecases/detail_drama_usecase.dart';
import '../../features/micro_drama/usecases/drama_episode_detail.dart';
import '../../features/profile/repositories/profile_datasource.dart';
import '../../features/profile/usecase/all_plan_usecase.dart';
import '../../features/profile/usecase/get_document_usecase.dart';
import '../../features/profile/usecase/get_help_usecase.dart';
import '../../features/web_series/datasource/series_datasource.dart';
import '../../features/web_series/usecase/all_series_usecase.dart';
import '../../features/web_series/usecase/detail_episode_usecase.dart';
import '../../features/web_series/usecase/series_detail_usecase.dart';
import '../services/navigation_service.dart';

import '../../features/auth/repositories/auth_datasource.dart';
import '../../features/profile/usecase/update_profile_usecase.dart';

part 'injection_auth.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  static BuildContext get currentContext {
    final ctx = navigatorState.currentContext;
    if (ctx == null) {
      throw FlutterError("Context not available");
    }
    return ctx;
  }

  static NavigationService get navigationService => getIt<NavigationService>();
  static GlobalKey<NavigatorState> get navigatorState =>
      getIt<NavigationService>().navigatorKey;

  static Future<void> initialDependency() async {
    final navigationService = NavigationService();
    getIt.registerLazySingleton<NavigationService>(() => navigationService);
    await _authDependency();
  }

  static Future<void> initial() async {
    await initialDependency();
    _registerGetXControllers();
  }

  /// Register all GetX controllers as permanent singletons via Get.lazyPut
  static void _registerGetXControllers() {
    // Home
    Get.lazyPut<CategoryController>(
      () => CategoryController(
        allCategoriesUsecase: getIt<AllCategoriesUsecase>(),
        categoryDetailUsecase: getIt<CategoryDetailUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ContentController>(
      () => ContentController(
        allContentUsecase: getIt<AllContentUsecase>(),
        searchContentUsecase: getIt<SearchcontentUsecase>(),
      ),
      fenix: true,
    );

    // Movie
    Get.lazyPut<MovieController>(
      () => MovieController(
        allMovieUsecase: getIt<AllMovieUsecase>(),
        movieDetailUsecase: getIt<MovieDetailUsecase>(),
      ),
      fenix: true,
    );

    // Web Series
    Get.lazyPut<SeriesController>(
      () => SeriesController(
        allSeriesUsecase: getIt<AllSeriesUsecase>(),
        seriesDetailUsecase: getIt<SeriesDetailUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<EpisodeController>(
      () => EpisodeController(
        allEpisodeUsecase: getIt<AllEpisodeUsecase>(),
        detailEpisodeUsecase: getIt<DetailEpisodeUsecase>(),
      ),
      fenix: true,
    );

    // Micro Drama
    Get.lazyPut<MicroDramaController>(
      () => MicroDramaController(
        allMicroDramaUsecase: getIt<AllMicroDramaUsecase>(),
        detailDramaUsecase: getIt<DetailDramaUsecase>(),
        dramaEpisodeDetail: getIt<DramaEpisodeDetail>(),
      ),
      fenix: true,
    );

    // Profile
    Get.lazyPut<HelpController>(
      () => HelpController(
        getHelpUsecase: getIt<GetHelpUsecase>(),
        getDocumentUsecase: getIt<GetDocumentUsecase>(),
        getSingleDocumentUsecase: getIt<SingleDocumentUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(
        updateProfileUsecase: getIt<UpdateProfileUsecase>(),
      ),
      fenix: true,
    );
    Get.lazyPut<PlanController>(
      () => PlanController(allPlanUsecase: getIt<AllPlanUsecase>()),
      fenix: true,
    );
  }
}
