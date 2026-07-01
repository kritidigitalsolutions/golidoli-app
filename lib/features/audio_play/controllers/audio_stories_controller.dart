import 'package:get/get.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class AudioStoriesController extends GetxController {
  final RxInt selectedCategoryIndex = 0.obs;
  final RxBool isLoading = false.obs;

  final List<String> categories = [
    'All',
    'Action',
    'Romance',
    'Thriller',
    'Horror',
    'Comedy',
  ];

  final List<AudioStoryModel> allStories = _generateStories();

  List<AudioStoryModel> get filteredStories {
    if (selectedCategoryIndex.value == 0) return allStories;
    final selectedGenre = categories[selectedCategoryIndex.value];
    return allStories
        .where((s) => s.genre == selectedGenre)
        .toList();
  }

  List<AudioStoryModel> get topAudioStories =>
      allStories.take(3).toList();

  List<AudioStoryModel> get romanticAudioStories =>
      allStories.where((s) => s.genre == 'Romance').take(3).toList();

  AudioStoryModel get heroBanner => allStories.first;

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
  }

  void onStoryTap(AudioStoryModel story) {
    Get.toNamed(AppRoutes.audioDetail, arguments: story);
  }
}

List<AudioStoryModel> _generateStories() {
  final episodes = List.generate(
    6,
    (i) => AudioEpisodeModel(
      id: 'ep_${i + 1}',
      title: 'Karmayoddha – Ep ${i + 1}',
      storyTitle: 'Karmayoddha',
      episodeNumber: i + 1,
      fileSize: '18 MB',
      imageUrl: 'https://picsum.photos/seed/karma${i + 1}/200/300',
      duration: const Duration(minutes: 12, seconds: 30),
    ),
  );

  return [
    AudioStoryModel(
      id: 'story_1',
      title: 'KARMAYODDHA',
      subtitle: 'The Rise of a Warrior',
      imageUrl: 'https://picsum.photos/seed/warrior1/700/400',
      genre: 'Action',
      rating: 4.8,
      totalEpisodes: 45,
      duration: '12h 30m',
      totalPlays: 12500,
      description:
          'The untold story of a warrior who fought against all odds to bring change in the world.',
      episodes: episodes,
    ),
    AudioStoryModel(
      id: 'story_2',
      title: 'ISHQ KI AAWAZ',
      subtitle: 'A Love Story',
      imageUrl: 'https://picsum.photos/seed/romance2/700/400',
      genre: 'Romance',
      rating: 4.6,
      totalEpisodes: 30,
      duration: '8h 15m',
      totalPlays: 9800,
      description:
          'A beautiful love story told through the voices of two souls separated by destiny.',
      episodes: episodes,
    ),
    AudioStoryModel(
      id: 'story_3',
      title: 'RAAZ KI RAAT',
      subtitle: 'Secrets of the Night',
      imageUrl: 'https://picsum.photos/seed/thriller3/700/400',
      genre: 'Thriller',
      rating: 4.7,
      totalEpisodes: 20,
      duration: '6h 00m',
      totalPlays: 7600,
      description:
          'A gripping thriller about secrets buried deep in the dark alleys of the city.',
      episodes: episodes,
    ),
    AudioStoryModel(
      id: 'story_4',
      title: 'PYAAR KA SAFAR',
      subtitle: 'Journey of Love',
      imageUrl: 'https://picsum.photos/seed/romance4/700/400',
      genre: 'Romance',
      rating: 4.5,
      totalEpisodes: 25,
      duration: '7h 00m',
      totalPlays: 8400,
      description: 'Two strangers meet on a train and discover love along the way.',
      episodes: episodes,
    ),
    AudioStoryModel(
      id: 'story_5',
      title: 'ANDHERA',
      subtitle: 'Into the Darkness',
      imageUrl: 'https://picsum.photos/seed/horror5/700/400',
      genre: 'Horror',
      rating: 4.4,
      totalEpisodes: 15,
      duration: '4h 30m',
      totalPlays: 5500,
      description: 'A haunting tale of a family moving into a mysterious mansion.',
      episodes: episodes,
    ),
    AudioStoryModel(
      id: 'story_6',
      title: 'COMEDY EXPRESS',
      subtitle: 'Laugh Your Heart Out',
      imageUrl: 'https://picsum.photos/seed/comedy6/700/400',
      genre: 'Comedy',
      rating: 4.3,
      totalEpisodes: 18,
      duration: '5h 00m',
      totalPlays: 4200,
      description: 'A hilarious ride through the everyday chaos of a quirky family.',
      episodes: episodes,
    ),
  ];
}
