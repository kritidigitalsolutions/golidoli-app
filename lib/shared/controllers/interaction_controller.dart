import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:golidoli_app/shared/models/like_dislike_response.dart';
import 'package:golidoli_app/shared/repositories/interaction_datasource.dart';

class InteractionController extends GetxController {
  static InteractionController get to {
    if (Get.isRegistered<InteractionController>()) {
      return Get.find<InteractionController>();
    }
    return Get.put(InteractionController(), permanent: true);
  }

  final InteractionDatasource _datasource = InteractionDatasource();

  final RxMap<String, int> likesCount = <String, int>{}.obs;
  final RxMap<String, int> dislikesCount = <String, int>{}.obs;
  final RxMap<String, bool> isLikedMap = <String, bool>{}.obs;
  final RxMap<String, bool> isDislikedMap = <String, bool>{}.obs;
  final RxMap<String, bool> loadingMap = <String, bool>{}.obs;

  void initContent({
    required String contentId,
    int initialLikes = 0,
    int initialDislikes = 0,
    bool initialIsLiked = false,
    bool initialIsDisliked = false,
  }) {
    if (contentId.isEmpty) return;
    likesCount.putIfAbsent(contentId, () => initialLikes);
    dislikesCount.putIfAbsent(contentId, () => initialDislikes);
    isLikedMap.putIfAbsent(contentId, () => initialIsLiked);
    isDislikedMap.putIfAbsent(contentId, () => initialIsDisliked);
  }

  int getLikes(String contentId, [int fallback = 0]) =>
      likesCount[contentId] ?? fallback;

  int getDislikes(String contentId, [int fallback = 0]) =>
      dislikesCount[contentId] ?? fallback;

  bool isLiked(String contentId) => isLikedMap[contentId] ?? false;

  bool isDisliked(String contentId) => isDislikedMap[contentId] ?? false;

  bool isLoading(String contentId) => loadingMap[contentId] ?? false;

  Future<LikeDislikeResponse?> toggleLike(String contentId, {bool showToast = false}) async {
    if (contentId.isEmpty) return null;
    if (isLoading(contentId)) return null;

    loadingMap[contentId] = true;
    try {
      final response = await _datasource.toggleLike(contentId);
      if (response != null && response.success) {
        likesCount[contentId] = response.totalLikes;
        dislikesCount[contentId] = response.totalDislikes;

        final msg = response.message.toLowerCase();
        if (msg.contains("added") || msg.contains("changed to like")) {
          isLikedMap[contentId] = true;
          isDislikedMap[contentId] = false;
        } else if (msg.contains("removed")) {
          isLikedMap[contentId] = false;
        }

        if (showToast && response.message.isNotEmpty) {
          Get.snackbar(
            'Like',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      }
      return response;
    } catch (e) {
      debugPrint("InteractionController.toggleLike Error: $e");
      Get.snackbar(
        'Error',
        'Could not update like. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
      );
      return null;
    } finally {
      loadingMap[contentId] = false;
    }
  }

  Future<LikeDislikeResponse?> toggleDislike(String contentId, {bool showToast = false}) async {
    if (contentId.isEmpty) return null;
    if (isLoading(contentId)) return null;

    loadingMap[contentId] = true;
    try {
      final response = await _datasource.toggleDislike(contentId);
      if (response != null && response.success) {
        likesCount[contentId] = response.totalLikes;
        dislikesCount[contentId] = response.totalDislikes;

        final msg = response.message.toLowerCase();
        if (msg.contains("added") || msg.contains("changed to dislike")) {
          isDislikedMap[contentId] = true;
          isLikedMap[contentId] = false;
        } else if (msg.contains("removed")) {
          isDislikedMap[contentId] = false;
        }

        if (showToast && response.message.isNotEmpty) {
          Get.snackbar(
            'Dislike',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      }
      return response;
    } catch (e) {
      debugPrint("InteractionController.toggleDislike Error: $e");
      Get.snackbar(
        'Error',
        'Could not update dislike. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
      );
      return null;
    } finally {
      loadingMap[contentId] = false;
    }
  }
}
