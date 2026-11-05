import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/home/models/category_detail_model.dart';
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

  final RxMap<String, List<ContentModel>> categoryContents =
      <String, List<ContentModel>>{}.obs;
  final RxBool isCategoryContentsLoading = false.obs;

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
        final visibleBanners = response.data!.where((b) => b.isVisible).toList();
        banners.assignAll(visibleBanners);
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
        // Active and visible categories sorted by priority (lowest number = highest priority)
        var topCats = response.categories
            .where((cat) => cat.isVisible)
            .toList();
        if (topCats.isEmpty) {
          topCats = List<CategoryModel>.from(response.categories)
              .where((cat) => cat.isVisible)
              .toList();
        }
        topCats.sort((a, b) => a.priority.compareTo(b.priority));
        categories.assignAll(topCats);

        // Fetch contents for active categories in parallel in background
        _fetchCategoriesContent(topCats);
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> _fetchCategoriesContent(List<CategoryModel> cats) async {
    try {
      isCategoryContentsLoading.value = true;
      await Future.wait(
        cats.map((cat) => _fetchCategoryContent(cat.id)),
      );
    } catch (e) {
      debugPrint("Error fetching category contents: $e");
    } finally {
      isCategoryContentsLoading.value = false;
    }
  }

  Future<void> _fetchCategoryContent(String categoryId) async {
    try {
      final response = await _homeDatasource.categoryDetail(
        id: categoryId,
        page: 0,
        size: 20,
      );
      if (response != null && response.content.isNotEmpty) {
        final visibleList = response.content.where((c) => c.isVisible).toList();
        visibleList.sort((a, b) {
          if (a.position != b.position) {
            if (a.position > 0 && b.position > 0) return a.position.compareTo(b.position);
            if (a.position > 0) return -1;
            if (b.position > 0) return 1;
          }
          if (a.priority != b.priority) return a.priority.compareTo(b.priority);
          return b.rating.compareTo(a.rating);
        });
        categoryContents[categoryId] = visibleList;
      }
    } catch (e) {
      debugPrint("Error fetching category content for $categoryId: $e");
    }
  }

  void onTabSelected(int index) => selectedTabIndex.value = index;
  void onBannerChanged(int index) => currentBannerIndex.value = index;
  void changePage(int index) => pageIndex.value = index;
  void changeTab(int index) => changePage(index);
}
