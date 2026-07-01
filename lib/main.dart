import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/features/home/controllers/home_controller.dart';
import 'package:golidoli_app/features/home/views/discover_tab.dart';
import 'package:golidoli_app/features/home/views/home_tab.dart';
import 'package:golidoli_app/features/home/views/reels_tab.dart';
import 'package:golidoli_app/features/home/views/watchlist_tab.dart';
import 'package:golidoli_app/features/profile/views/profile_screen.dart';
import 'package:golidoli_app/routes/app_pages.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/shared/widgets/bottom_nav_bar.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF08001F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: [
        ...AppPages.pages,
        GetPage(
          name: AppRoutes.home,
          page: () => MyHomePage(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final int? initialIndex;
  MyHomePage({super.key, this.initialIndex});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTap(),
      WatchlistScreen(),
      ReelsTab(),
      DiscoverTab(),
      ProfileScreen(),
    ];

    if (initialIndex != null && controller.selectedIndex.value == 0) {
      controller.changeTab(initialIndex!.clamp(0, pages.length - 1).toInt());
    }

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.backgroundColor,
        bottomNavigationBar: BottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        ),
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),
    );
  }
}
