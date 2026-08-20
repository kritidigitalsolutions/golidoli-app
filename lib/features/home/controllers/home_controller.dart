import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/home/models/category_model.dart';
import 'package:golidoli_app/features/home/models/home_banner_model.dart';
import 'package:golidoli_app/features/home/repositories/home_datasource.dart';

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

  final List<Map<String, dynamic>> continueWatching = [
    {
      'title': 'Forbidden Love',
      'episode': 'S1 E01',
      'progress': 0.35,
      'image': 'https://picsum.photos/seed/show1/200/300',
    },
    {
      'title': 'The Hour You',
      'episode': 'S1 E03',
      'progress': 0.6,
      'image': 'https://picsum.photos/seed/show2/200/300',
    },
    {
      'title': 'Squid Game',
      'episode': 'S1 E05',
      'progress': 0.8,
      'image': 'https://picsum.photos/seed/show3/200/300',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchHomeBanners();
    fetchCategories();
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
