import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/constants/app_colors.dart';
import 'package:golidoli_app/core/di/injection.dart';
import 'package:golidoli_app/features/home/controllers/home_controller.dart';
import 'package:golidoli_app/features/home/views/discover_tab.dart';
import 'package:golidoli_app/features/home/views/home_tab.dart';
import 'package:golidoli_app/features/home/views/reels_tab.dart';
import 'package:golidoli_app/features/home/views/watchlist_tab.dart';
import 'package:golidoli_app/features/profile/views/profile_screen.dart';
import 'package:golidoli_app/routes/app_pages.dart';
import 'package:golidoli_app/routes/app_routes.dart';
import 'package:golidoli_app/shared/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.initial();

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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Golidoli',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
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
          page: () => const MyHomePage(),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int? initialIndex;

  const MyHomePage({super.key, this.initialIndex});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());

    // Handle initial index after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialIndex != null && controller.selectedIndex.value == 0) {
        final pagesLength = _getPages().length;
        final validIndex = widget.initialIndex!.clamp(0, pagesLength - 1);
        controller.changeTab(validIndex);
      }
    });
  }

  @override
  void dispose() {
    // Clean up GetX controller if needed
    // Get.delete<HomeController>();
    super.dispose();
  }

  List<Widget> _getPages() {
    return const [
      HomeTab(),
      WatchlistScreen(),
      ReelsTab(),
      DiscoverTab(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _getPages();

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
