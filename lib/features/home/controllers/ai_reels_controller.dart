import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/features/home/controllers/home_controller.dart';
import 'package:golidoli_app/features/home/models/ai_reel_model.dart';
import 'package:golidoli_app/features/home/repositories/ai_reels_datasource.dart';

class AiReelsController extends GetxController {
  static AiReelsController get to => Get.isRegistered<AiReelsController>()
      ? Get.find<AiReelsController>()
      : Get.put(AiReelsController());

  final AiReelsDatasource _datasource = AiReelsDatasource();

  // State
  final RxList<AiReelModel> reels = <AiReelModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingNextBatch = false.obs;
  final RxString sessionId = ''.obs;
  final RxBool hasMore = true.obs;
  final RxBool allWatched = false.obs;
  final RxBool hasUnwatched = true.obs;
  final RxInt currentIndex = 0.obs;
  final RxInt selectedFeedTab = 1.obs; // 0 = For You, 1 = Trending
  final RxBool isReplayMode = false.obs;
  final RxBool isMuted = false.obs;

  // Track interactions locally per session to avoid duplicate API calls
  final Set<String> _viewedReelIds = <String>{};
  final Set<String> _completedReelIds = <String>{};

  // Local likes & shares tracking
  final RxMap<String, int> likesCountMap = <String, int>{}.obs;
  final RxMap<String, bool> isLikedMap = <String, bool>{}.obs;
  final RxMap<String, bool> isLikeLoadingMap = <String, bool>{}.obs;
  final RxMap<String, int> sharesCountMap = <String, int>{}.obs;

  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitialFeed();
  }

  /// Initial load when user opens AI Reels
  Future<void> fetchInitialFeed({bool isReplay = false}) async {
    try {
      isLoading.value = true;
      if (!isReplay) {
        sessionId.value = '';
      }
      _viewedReelIds.clear();
      _completedReelIds.clear();
      currentIndex.value = 0;
      isReplayMode.value = isReplay;

      final response = await _datasource.fetchAiReels(
        limit: 10,
        sessionId: isReplay ? sessionId.value : null,
        replay: isReplay,
      );

      sessionId.value = response.pagination.sessionId;
      hasMore.value = response.pagination.hasMore;
      allWatched.value = response.meta.allWatched;
      hasUnwatched.value = response.meta.hasUnwatched;

      reels.assignAll(response.data);

      // Initialize like & share maps without losing user state
      for (final r in response.data) {
        likesCountMap[r.id] = r.likes;
        if (!isLikedMap.containsKey(r.id)) {
          isLikedMap[r.id] = r.isLiked;
        }
        sharesCountMap[r.id] = r.shares;
      }

      // Automatically record view for the first reel if available
      if (reels.isNotEmpty) {
        recordView(reels.first.id);
      }

      if (response.data.isEmpty && allWatched.value) {
        if (isReelsTabActive) {
          showAllWatchedPrompt();
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching initial AI Reels: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Background prefetch for next batch with the SAME sessionId
  Future<void> fetchNextBatch() async {
    if (isFetchingNextBatch.value || !hasMore.value || allWatched.value) {
      return;
    }

    try {
      isFetchingNextBatch.value = true;
      debugPrint(
        "🔄 Background prefetching next AI Reels batch with sessionId: ${sessionId.value}",
      );

      final response = await _datasource.fetchAiReels(
        limit: 10,
        sessionId: sessionId.value,
        replay: isReplayMode.value,
      );

      // Keep the same session ID
      if (response.pagination.sessionId.isNotEmpty) {
        sessionId.value = response.pagination.sessionId;
      }
      hasMore.value = response.pagination.hasMore;
      allWatched.value = response.meta.allWatched;
      hasUnwatched.value = response.meta.hasUnwatched;

      if (response.data.isNotEmpty) {
        // Append unique items only
        final existingIds = reels.map((r) => r.id).toSet();
        final newItems = response.data
            .where((r) => !existingIds.contains(r.id))
            .toList();

        for (final r in newItems) {
          likesCountMap[r.id] = r.likes;
          if (!isLikedMap.containsKey(r.id)) {
            isLikedMap[r.id] = r.isLiked;
          }
          sharesCountMap[r.id] = r.shares;
        }

        reels.addAll(newItems);
      } else {
        hasMore.value = false;
        if (response.meta.allWatched) {
          allWatched.value = true;
        }
      }
    } catch (e) {
      debugPrint("❌ Error prefetching next batch: $e");
    } finally {
      isFetchingNextBatch.value = false;
    }
  }

  /// Called when user swipes to a page
  void onPageChanged(int index) {
    currentIndex.value = index;

    if (index >= 0 && index < reels.length) {
      final currentReel = reels[index];
      recordView(currentReel.id);
    }

    // Prefetch next batch 2-3 reels before the end
    if (index >= reels.length - 3 &&
        hasMore.value &&
        !isFetchingNextBatch.value) {
      fetchNextBatch();
    }
  }

  /// Record view in the background without blocking UI
  void recordView(String reelId) {
    if (reelId.isEmpty || _viewedReelIds.contains(reelId)) return;
    _viewedReelIds.add(reelId);
    _datasource.recordView(reelId);
  }

  /// Record reel complete in the background when finished
  void recordComplete(String reelId) {
    if (reelId.isEmpty || _completedReelIds.contains(reelId)) return;
    _completedReelIds.add(reelId);
    _datasource.recordComplete(reelId);

    // If on the last reel and no more items / allWatched is true, show prompt
    if (currentIndex.value >= reels.length - 1 &&
        (allWatched.value || !hasMore.value)) {
      showAllWatchedPrompt();
    }
  }

  /// Toggle like for reel via API: POST /api/interaction/toggle/like/aiReel/:id
  Future<void> toggleReelLike(String reelId) async {
    if (reelId.isEmpty) return;
    if (isLikeLoadingMap[reelId] == true) return;

    isLikeLoadingMap[reelId] = true;

    final wasLiked = isLikedMap[reelId] ?? false;
    final prevCount = likesCountMap[reelId] ?? 0;

    // Optimistic UI update
    if (wasLiked) {
      isLikedMap[reelId] = false;
      likesCountMap[reelId] = (prevCount - 1).clamp(0, 99999999);
    } else {
      isLikedMap[reelId] = true;
      likesCountMap[reelId] = prevCount + 1;
    }

    try {
      final response = await _datasource.toggleLike(reelId);
      if (response != null && response.success) {
        final msg = response.message.toLowerCase();
        if (msg.contains("added") ||
            msg.contains("liked") ||
            (msg.contains("like") && !msg.contains("removed"))) {
          isLikedMap[reelId] = true;
        } else if (msg.contains("removed") || msg.contains("unliked")) {
          isLikedMap[reelId] = false;
        }
        if (response.totalLikes >= 0) {
          likesCountMap[reelId] = response.totalLikes;
        }
      } else {
        // Rollback on non-success
        isLikedMap[reelId] = wasLiked;
        likesCountMap[reelId] = prevCount;
      }
    } catch (e) {
      debugPrint("⚠️ toggleReelLike error: $e");
      // Rollback on error
      isLikedMap[reelId] = wasLiked;
      likesCountMap[reelId] = prevCount;
    } finally {
      isLikeLoadingMap[reelId] = false;
    }
  }

  /// Helper for double-tap on screen (only likes if not already liked)
  Future<void> likeReelIfNotLiked(String reelId) async {
    if (reelId.isEmpty) return;
    final isAlreadyLiked = isLikedMap[reelId] ?? false;
    if (!isAlreadyLiked) {
      await toggleReelLike(reelId);
    }
  }

  /// Record and increment share count via API: POST /api/ai-reels/:id/share
  Future<void> recordShare(String reelId) async {
    if (reelId.isEmpty) return;

    // Optimistic increment
    final currentShares = sharesCountMap[reelId] ?? 0;
    sharesCountMap[reelId] = currentShares + 1;

    // Call API in background
    try {
      final response = await _datasource.recordShare(reelId);
      if (response != null && response.success) {
        sharesCountMap[reelId] = response.shares;
      }
    } catch (e) {
      debugPrint("⚠️ recordShare error: $e");
    }
  }

  int getLikes(String reelId, int fallback) {
    return likesCountMap[reelId] ?? fallback;
  }

  bool isLiked(String reelId) {
    return isLikedMap[reelId] ?? false;
  }

  int getShares(String reelId, int fallback) {
    return sharesCountMap[reelId] ?? fallback;
  }

  /// Whether the user is currently viewing the AI Reels tab (index 2)
  bool get isReelsTabActive {
    if (Get.isRegistered<HomeController>()) {
      return Get.find<HomeController>().selectedIndex.value == 2;
    }
    return true;
  }

  /// Shows the "All Watched" congratulations modal
  void showAllWatchedPrompt() {
    if (!isReelsTabActive) return;
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E24),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withValues(alpha: 0.2),
                ),
                child: const Center(
                  child: Text('🎉', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "You've watched all available Reels. Would you like to watch again?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'No, Thanks',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        restartReplay();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B70),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Watch Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  /// Restart in replay mode
  void restartReplay() {
    fetchInitialFeed(isReplay: true);
  }
}
