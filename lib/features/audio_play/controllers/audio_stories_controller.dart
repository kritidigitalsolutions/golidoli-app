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
  final RxList<AudioProgressModel> continueListeningList =
      <AudioProgressModel>[].obs;

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

      final activeSorted = result.where((c) => c.isActive).toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));

      _populateCategories(activeSorted);
    } catch (e) {
      debugPrint("fetchCategories error: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  void _populateCategories(List<AudioCategoryModel> apiCats) {
    final Map<String, AudioCategoryModel> catMap = {};
    for (var c in apiCats) {
      if (c.name.trim().isNotEmpty && !catMap.containsKey(c.name.trim().toLowerCase())) {
        catMap[c.name.trim().toLowerCase()] = c;
      }
    }

    // Also collect categories from allStories
    for (var story in allStories) {
      for (var c in story.categories) {
        if (c.name.trim().isNotEmpty && !catMap.containsKey(c.name.trim().toLowerCase())) {
          catMap[c.name.trim().toLowerCase()] = c;
        }
      }
      if (story.genre.trim().isNotEmpty && story.genre != 'Audio Story' && !catMap.containsKey(story.genre.trim().toLowerCase())) {
        catMap[story.genre.trim().toLowerCase()] = AudioCategoryModel(
          id: story.categoryId,
          name: story.genre,
        );
      }
    }

    final list = <AudioCategoryModel>[
      const AudioCategoryModel(
        id: 'all',
        name: 'All',
        description: 'All Audio Stories',
      ),
      ...catMap.values,
    ];
    categories.assignAll(list);
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
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  static const int pageSize = 12;

  Future<void> fetchAllStories() async {
    currentPage = 1;
    hasMore.value = true;
    try {
      final stories = await _repository.getAudioStories(page: 1, limit: pageSize);
      allStories.assignAll(stories);
      if (stories.length < pageSize) {
        hasMore.value = false;
      }
      _populateCategories(categories.where((c) => c.id != 'all').toList());
      _updateCategoryStories();
    } catch (e) {
      debugPrint("fetchAllStories error: $e");
    }
  }

  Future<void> fetchMoreStories() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = currentPage + 1;
      final selectedCat = (selectedCategoryIndex.value < categories.length &&
              categories[selectedCategoryIndex.value].id != 'all')
          ? categories[selectedCategoryIndex.value].id
          : null;

      final newStories = await _repository.getAudioStories(
        categoryId: selectedCat,
        page: nextPage,
        limit: pageSize,
      );

      if (newStories.isNotEmpty) {
        final existingIds = allStories.map((s) => s.id).toSet();
        final filtered = newStories.where((s) => !existingIds.contains(s.id)).toList();
        if (filtered.isNotEmpty) {
          allStories.addAll(filtered);
          currentPage = nextPage;
          _updateCategoryStories();
        } else {
          hasMore.value = false;
        }
        if (newStories.length < pageSize) {
          hasMore.value = false;
        }
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      debugPrint("fetchMoreStories error: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Helper to check if a story belongs to a given category
  bool _storyMatchesCategory(AudioStoryModel story, AudioCategoryModel cat) {
    if (cat.id == 'all') return true;

    final targetName = cat.name.trim().toLowerCase();
    final targetId = cat.id.trim();
    final targetSlug = cat.slug.trim().toLowerCase();

    // Check category id
    if (targetId.isNotEmpty) {
      if (story.categoryId.trim() == targetId) return true;
      if (story.categories.any((c) => c.id.trim() == targetId)) return true;
    }

    // Check slug
    if (targetSlug.isNotEmpty) {
      if (story.categories.any((c) => c.slug.trim().toLowerCase() == targetSlug)) {
        return true;
      }
    }

    // Check name
    if (targetName.isNotEmpty) {
      if (story.genre.trim().toLowerCase() == targetName) return true;
      if (story.categories.any((c) => c.name.trim().toLowerCase() == targetName)) {
        return true;
      }
    }

    return false;
  }

  /// 5. Category Selection
  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
    _updateCategoryStories();
  }

  void _updateCategoryStories() {
    final index = selectedCategoryIndex.value;
    if (index <= 0 || index >= categories.length) {
      categoryStories.assignAll(allStories);
      return;
    }

    final selectedCat = categories[index];
    final filtered = allStories.where((s) => _storyMatchesCategory(s, selectedCat)).toList();
    categoryStories.assignAll(filtered);
  }

  List<AudioStoryModel> get filteredCategoryStories {
    final index = selectedCategoryIndex.value;
    if (index <= 0 || index >= categories.length) return allStories;

    final selectedCat = categories[index];
    return allStories.where((s) => _storyMatchesCategory(s, selectedCat)).toList();
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

  List<AudioStoryModel> get topAudioStories => topRatedStories.isNotEmpty
      ? topRatedStories
      : allStories.take(5).toList();

  List<AudioStoryModel> get recentlyAdded => recentlyAddedStories.isNotEmpty
      ? recentlyAddedStories
      : allStories.skip(2).take(5).toList();

  void onStoryTap(AudioStoryModel story) {
    Get.toNamed(
      AppRoutes.audioDetail,
      arguments: story.id.isNotEmpty ? story.id : story,
    );
  }

  void onContinueListeningTap(AudioProgressModel item) {
    final ep = item.episode;
    if (ep != null) {
      final storyId = ep.storyId;
      AudioStoryModel? cachedStory = allStories.firstWhereOrNull(
        (s) => s.id == storyId,
      );
      cachedStory ??= featuredStories.firstWhereOrNull(
        (s) => s.id == storyId,
      );

      final Map<String, dynamic> args = {
        'storyId': storyId,
        'episodeId': ep.id,
        'episode': ep,
        'progressSeconds': item.progressSeconds,
      };
      if (cachedStory != null) {
        args['story'] = cachedStory;
      }

      Get.toNamed(
        AppRoutes.audioPlayer,
        arguments: args,
      );
    }
  }
}
