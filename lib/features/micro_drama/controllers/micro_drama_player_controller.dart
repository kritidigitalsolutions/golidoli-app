import 'package:get/get.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class MicroDramaPlayerController extends GetxController {
  late MicroDramaModel drama;

  final RxInt currentIndex = 0.obs;
  final RxBool isLiked = false.obs;

  // Feed list of dramas for vertical swipe
  final List<MicroDramaModel> feed = _buildFeed();

  MicroDramaModel get currentDrama => feed[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is MicroDramaModel) {
      drama = Get.arguments as MicroDramaModel;
      // Put the passed drama at the front of the feed
      final idx = feed.indexWhere((d) => d.id == drama.id);
      if (idx > 0) {
        currentIndex.value = idx;
      }
    } else {
      drama = feed.first;
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    isLiked.value = false;
  }

  void toggleLike() => isLiked.value = !isLiked.value;

  void onShowMore() {
    Get.toNamed(AppRoutes.microDramaDetail, arguments: currentDrama);
  }

  String formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}

List<MicroDramaModel> _buildFeed() => [
      MicroDramaModel(
        id: 'd5',
        title: 'Forbidden Love',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama5/400/600',
        genre: 'Romance',
        rating: 4.5,
        totalReviews: 8700,
        totalEpisodes: 14,
        tags: ['18+', 'Romance', 'Drama'],
        story: 'When love and revenge collide, destiny writes a forbidden story.',
        likes: 12800,
        comments: 11500,
        shares: 50000,
      ),
      MicroDramaModel(
        id: 'd1',
        title: 'My Racer\nStepbrother',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama1/400/600',
        genre: 'Romance',
        rating: 4.8,
        totalReviews: 12500,
        totalEpisodes: 16,
        tags: ['18+', 'Romance', 'Drama'],
        story: 'Two strangers meet by chance, but destiny leads them into a forbidden romance.',
        likes: 12800,
        comments: 11500,
        shares: 50000,
      ),
      MicroDramaModel(
        id: 'd4',
        title: 'Connect',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama4/400/600',
        genre: 'Romance',
        rating: 4.8,
        totalReviews: 12500,
        totalEpisodes: 16,
        tags: ['18+', 'Romance', 'Drama'],
        story: 'Two strangers meet by chance, but destiny leads them into a forbidden romance.',
        likes: 9800,
        comments: 8300,
        shares: 37000,
      ),
      MicroDramaModel(
        id: 'd3',
        title: 'The True\nHeiress Strikes Back',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama3/400/600',
        genre: 'Action',
        rating: 4.7,
        totalReviews: 11000,
        totalEpisodes: 20,
        tags: ['18+', 'Action', 'Drama'],
        story: 'She was stripped of everything. Now she returns to reclaim what was always hers — with fire.',
        likes: 11200,
        comments: 10300,
        shares: 44000,
      ),
    ];
