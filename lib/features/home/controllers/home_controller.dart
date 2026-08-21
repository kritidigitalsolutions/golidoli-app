import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/home/models/category_model.dart';
import 'package:golidoli_app/features/home/models/home_banner_model.dart';
import 'package:golidoli_app/features/home/repositories/home_datasource.dart';
import 'package:golidoli_app/features/micro_drama/controllers/continue_watching_controller.dart';

class HomeController extends GetxController {
  final HomeDatasource _homeDatasource = HomeDatasource();

  final RxInt pageIndex = 0.obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt selectedTabIndex = 0.obs;

  final RxList<HomeBannerItem> banners = <HomeBannerItem>[].obs;
  final RxBool isBannersLoading = false.obs;

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isCategoriesLoading = false.obs;

  RxInt get selectedIndex => pageIndex;

  final List<String> tabs = [
    'For You',
    'Movies',
    'Web Series',
  ];

  // ── Continue Watching via shared controller ──────────────────────────────
  ContinueWatchingController get cwController =>
      Get.isRegistered<ContinueWatchingController>()
          ? Get.find<ContinueWatchingController>()
          : Get.put(ContinueWatchingController());

  @override
  void onInit() {
    super.onInit();
    fetchHomeBanners();
    fetchCategories();
    cwController.fetchForHome();
  }

  Future<void> fetchHomeBanners() async {
    try {
      isBannersLoading.value = true;
      final response = await _homeDatasource.fetchHomeBanners();
      if (response != null &&
          response.data != null &&
          response.data!.isNotEmpty) {
        banners.assignAll(response.data!);
      }
    } catch (e) {
      debugPrint("Error fetching home banners: $e");
    } finally {
      isBannersLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final response = await _homeDatasource.allCategories();
      if (response != null && response.categories.isNotEmpty) {
        // Priority <= 10 active categories sorted by priority
        final topCats = response.categories
            .where((cat) => cat.isActive && cat.priority <= 10)
            .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority));
        categories.assignAll(topCats);
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  void onTabSelected(int index) => selectedTabIndex.value = index;
  void onBannerChanged(int index) => currentBannerIndex.value = index;
  void changePage(int index) => pageIndex.value = index;
  void changeTab(int index) => changePage(index);
}
