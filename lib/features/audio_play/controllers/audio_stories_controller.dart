import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/features/audio_play/repositories/audio_repository.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class AudioStoriesController extends GetxController {
  final AudioRepository _repository = AudioRepository();

  // Categories
  final RxList<AudioCategoryModel> categories = <AudioCategoryModel>[].obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isCategoriesLoading = false.obs;

  // Home Feed
  final RxBool isLoading = false.obs;
  final RxList<AudioStoryModel> featuredStories = <AudioStoryModel>[].obs;
  final RxList<AudioStoryModel> recentlyAddedStories = <AudioStoryModel>[].obs;
  final RxList<AudioStoryModel> topRatedStories = <AudioStoryModel>[].obs;
  final RxList<AudioStoryModel> allStories = <AudioStoryModel>[].obs;
  final RxList<AudioStoryModel> categoryStories = <AudioStoryModel>[].obs;
  final RxList<AudioProgressModel> continueListeningList = <AudioProgressModel>[].obs;

  // Search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<AudioStoryModel> searchResults = <AudioStoryModel>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    await Future.wait([
      fetchCategories(),
      fetchHomeFeed(),
      fetchContinueListening(),
      fetchAllStories(),
    ]);
    isLoading.value = false;
  }

  /// 1. Fetch Categories
  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final result = await _repository.getAudioCategories();
      final list = <AudioCategoryModel>[
        const AudioCategoryModel(id: 'all', name: 'All', description: 'All Audio Stories'),
        ...result.where((c) => c.isActive),
      ];
      categories.assignAll(list);
    } catch (e) {
      debugPrint("fetchCategories error: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  /// 2. Fetch Home Feed (Featured, Recently Added, Top Rated)
  Future<void> fetchHomeFeed() async {
    try {
      final feed = await _repository.getAudioStoriesHome();
      if (feed != null) {
        featuredStories.assignAll(feed.featured);
        recentlyAddedStories.assignAll(feed.recentlyAdded);
        topRatedStories.assignAll(feed.topRated);
      }
    } catch (e) {
      debugPrint("fetchHomeFeed error: $e");
    }
  }

  /// 3. Fetch Continue Listening Feed
  Future<void> fetchContinueListening() async {
    try {
      final list = await _repository.getContinueListening();
      continueListeningList.assignAll(list);
    } catch (e) {
      debugPrint("fetchContinueListening error: $e");
    }
  }

  /// 4. Fetch All Stories
  Future<void> fetchAllStories() async {
    try {
      final stories = await _repository.getAudioStories();
      allStories.assignAll(stories);
      if (categoryStories.isEmpty && stories.isNotEmpty) {
        categoryStories.assignAll(stories);
      }
    } catch (e) {
      debugPrint("fetchAllStories error: $e");
    }
  }

  /// 5. Category Selection
  void onCategorySelected(int index) async {
    selectedCategoryIndex.value = index;
    if (index == 0) {
      categoryStories.assignAll(allStories);
      return;
    }

    final selectedCat = categories[index];
    try {
      isLoading.value = true;
      final stories = await _repository.getAudioStories(categoryId: selectedCat.id);
      categoryStories.assignAll(stories);
    } catch (e) {
      debugPrint("onCategorySelected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 6. Search Stories
  Future<void> onSearchChanged(String query) async {
    searchQuery.value = query.trim();
    if (searchQuery.value.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    try {
      isSearching.value = true;
      final results = await _repository.searchAudioStories(searchQuery.value);
      searchResults.assignAll(results);
    } catch (e) {
      debugPrint("search error: $e");
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  // Getters for display
  AudioStoryModel? get heroBanner {
    if (featuredStories.isNotEmpty) return featuredStories.first;
    if (allStories.isNotEmpty) return allStories.first;
    return null;
  }

  List<AudioStoryModel> get topAudioStories =>
      topRatedStories.isNotEmpty ? topRatedStories : allStories.take(5).toList();

  List<AudioStoryModel> get recentlyAdded =>
      recentlyAddedStories.isNotEmpty ? recentlyAddedStories : allStories.skip(2).take(5).toList();

  void onStoryTap(AudioStoryModel story) {
    Get.toNamed(AppRoutes.audioDetail, arguments: story.id.isNotEmpty ? story.id : story);
  }

  void onContinueListeningTap(AudioProgressModel item) {
    final ep = item.episode;
    if (ep != null) {
      Get.toNamed(
        AppRoutes.audioPlayer,
        arguments: {
          'storyId': ep.storyId,
          'episodeId': ep.id,
          'progressSeconds': item.progressSeconds,
        },
      );
    }
  }
}
