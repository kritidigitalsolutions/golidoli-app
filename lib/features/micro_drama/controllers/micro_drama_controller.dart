import 'package:get/get.dart';
import 'package:golidoli_app/features/micro_drama/models/micro_drama_model.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class MicroDramaController extends GetxController {
  final RxInt selectedCategoryIndex = 0.obs;

  final List<String> categories = [
    'All',
    'Action',
    'Romance',
    'Thriller',
    'Horror',
    'Comedy',
  ];

  final List<MicroDramaModel> allDramas = _buildDramas();

  List<MicroDramaModel> get filteredDramas {
    if (selectedCategoryIndex.value == 0) return allDramas;
    final genre = categories[selectedCategoryIndex.value];
    return allDramas.where((d) => d.genre == genre).toList();
  }

  MicroDramaModel get heroDrama => allDramas.first;

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  void onDramaTap(MicroDramaModel drama) {
    Get.toNamed(AppRoutes.microDramaDetail, arguments: drama);
  }
}

List<MicroDramaModel> _buildDramas() => [
      MicroDramaModel(
        id: 'd1',
        title: 'My Racer\nStepbrother',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama1/400/600',
        genre: 'Romance',
        rating: 4.8,
        totalReviews: 12500,
        totalEpisodes: 16,
        tags: ['18+', 'Romance', 'Drama', '16 Episodes'],
        story:
            'Two strangers meet by chance, but destiny leads them into a forbidden romance.',
        likes: 12800,
        comments: 11500,
        shares: 50000,
      ),
      MicroDramaModel(
        id: 'd2',
        title: 'The Truth Behind\nWomen\'s Moan',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama2/400/600',
        genre: 'Thriller',
        rating: 4.6,
        totalReviews: 9200,
        totalEpisodes: 12,
        tags: ['18+', 'Thriller', 'Drama', '12 Episodes'],
        story:
            'Secrets buried in silence unravel when a young woman discovers the truth that shakes her world.',
        likes: 9400,
        comments: 8100,
        shares: 31000,
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
        tags: ['18+', 'Action', 'Drama', '20 Episodes'],
        story:
            'She was stripped of everything. Now she returns to reclaim what was always hers — with fire.',
        likes: 11200,
        comments: 10300,
        shares: 44000,
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
        tags: ['18+', 'Romance', 'Drama', '16 Episodes'],
        story:
            'Two strangers meet by chance, but destiny leads them into a forbidden romance.',
        likes: 12800,
        comments: 11500,
        shares: 50000,
      ),
      MicroDramaModel(
        id: 'd5',
        title: 'Forbidden Love',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama5/400/600',
        genre: 'Romance',
        rating: 4.5,
        totalReviews: 8700,
        totalEpisodes: 14,
        tags: ['18+', 'Romance', 'Drama', '14 Episodes'],
        story:
            'When love and revenge collide, destiny writes a forbidden story.',
        likes: 12800,
        comments: 11500,
        shares: 50000,
      ),
      MicroDramaModel(
        id: 'd6',
        title: 'An Unapproachable\nMan',
        subtitle: 'Episode 01',
        imageUrl: 'https://picsum.photos/seed/drama6/400/600',
        genre: 'Action',
        rating: 4.4,
        totalReviews: 7600,
        totalEpisodes: 10,
        tags: ['18+', 'Action', 'Drama', '10 Episodes'],
        story: 'Cold, ruthless, and untouchable — until she walks into his life.',
        likes: 7800,
        comments: 6200,
        shares: 22000,
      ),
    ];
