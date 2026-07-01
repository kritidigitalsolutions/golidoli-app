import 'package:get/get.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class MicroDramaDetailController extends GetxController {
  late MicroDramaModel drama;
  final RxBool isInWatchlist = false.obs;
  final RxInt selectedEpisode = 0.obs;

  // Generate episodes for the drama
  List<MicroDramaEpisodeModel> get episodes => List.generate(
        drama.totalEpisodes,
        (i) => MicroDramaEpisodeModel(
          id: 'ep_${i + 1}',
          episodeNumber: i + 1,
          title: 'Episode ${i + 1}',
          isLocked: i > 4,
        ),
      );

  // Episodes to display in grid (E1-E8 visible at top)
  List<MicroDramaEpisodeModel> get visibleEpisodes =>
      episodes.take(8).toList();

  // Similar dramas list
  final List<MicroDramaModel> similarDramas = _buildSimilar();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is MicroDramaModel) {
      drama = Get.arguments as MicroDramaModel;
    } else {
      drama = _fallback();
    }
  }

  void toggleWatchlist() => isInWatchlist.value = !isInWatchlist.value;

  void onEpisodeTap(int episodeIndex) {
    selectedEpisode.value = episodeIndex;
    Get.toNamed(AppRoutes.microDramaPlayer, arguments: drama);
  }

  void onStartWatching() {
    Get.toNamed(AppRoutes.microDramaPlayer, arguments: drama);
  }

  void onSimilarDramaTap(MicroDramaModel d) {
    Get.toNamed(AppRoutes.microDramaDetail, arguments: d);
  }
}

MicroDramaModel _fallback() => MicroDramaModel(
      id: 'd4',
      title: 'Connect',
      subtitle: 'Episode 01',
      imageUrl: 'https://picsum.photos/seed/drama4/400/600',
      genre: 'Romance',
      rating: 4.8,
      totalReviews: 12500,
      totalEpisodes: 16,
      tags: ['18+', 'Romance', 'Drama', '16 Episodes'],
      story:
          'Two strangers meet by chance, but destiny leads them into a forbidden romance.',
    );

List<MicroDramaModel> _buildSimilar() => [
      MicroDramaModel(
        id: 's1',
        title: 'The Truth Behind\nWomen\'s Moan',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama2/400/600',
        genre: 'Thriller',
        rating: 4.6,
        totalReviews: 9200,
        totalEpisodes: 12,
        tags: ['18+', 'Thriller'],
        story: 'Secrets buried in silence unravel.',
      ),
      MicroDramaModel(
        id: 's2',
        title: 'The True\nHeiress Strikes Back',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama3/400/600',
        genre: 'Action',
        rating: 4.7,
        totalReviews: 11000,
        totalEpisodes: 20,
        tags: ['18+', 'Action'],
        story: 'She returns to reclaim what was always hers.',
      ),
      MicroDramaModel(
        id: 's3',
        title: 'An Unapproachable\nMan',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama6/400/600',
        genre: 'Action',
        rating: 4.4,
        totalReviews: 7600,
        totalEpisodes: 10,
        tags: ['18+', 'Action'],
        story: 'Cold, ruthless, and untouchable.',
      ),
      MicroDramaModel(
        id: 's4',
        title: 'The Truth Behind\nWomen\'s Moan',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/similar4/400/600',
        genre: 'Thriller',
        rating: 4.5,
        totalReviews: 8100,
        totalEpisodes: 12,
        tags: ['18+', 'Thriller'],
        story: 'Secrets buried in silence unravel.',
      ),
      MicroDramaModel(
        id: 's5',
        title: 'The True\nHeiress Strikes Back',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/similar5/400/600',
        genre: 'Action',
        rating: 4.6,
        totalReviews: 10000,
        totalEpisodes: 20,
        tags: ['18+', 'Action'],
        story: 'She returns to reclaim everything.',
      ),
      MicroDramaModel(
        id: 's6',
        title: 'An Unapproachable\nMan',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/similar6/400/600',
        genre: 'Action',
        rating: 4.3,
        totalReviews: 6400,
        totalEpisodes: 10,
        tags: ['18+', 'Action'],
        story: 'Cold, ruthless, and untouchable.',
      ),
    ];
