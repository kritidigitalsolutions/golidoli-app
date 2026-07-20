import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:golidoli_app/features/movie/bloc/movie_bloc.dart';
import 'package:golidoli_app/features/movie/repositories/movie_datasource.dart';
import 'package:golidoli_app/features/movie/usecase/all_movie_usecase.dart';
import 'package:golidoli_app/features/movie/usecase/movie_detail_usecase.dart';
import 'package:golidoli_app/features/profile/usecase/single_document_usecase.dart';
import 'package:golidoli_app/features/web_series/bloc/episode_bloc/episode_bloc.dart';
import 'package:golidoli_app/features/web_series/bloc/series_bloc/series_bloc.dart';
import 'package:golidoli_app/features/web_series/usecase/all_episode_usecase.dart';

import '../../features/profile/bloc/document_bloc/help_cubit.dart';
import '../../features/profile/repositories/profile_datasource.dart';
import '../../features/profile/usecase/get_document_usecase.dart';
import '../../features/profile/usecase/get_help_usecase.dart';
import '../../features/web_series/datasource/series_datasource.dart';
import '../../features/web_series/usecase/all_series_usecase.dart';
import '../../features/web_series/usecase/detail_episode_usecase.dart';
import '../../features/web_series/usecase/series_detail_usecase.dart';
import '../services/navigation_service.dart';

part 'injection_auth.dart';
part 'injection_block.dart';

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
  }
}
