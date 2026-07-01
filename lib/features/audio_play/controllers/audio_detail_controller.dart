import 'package:get/get.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/routes/app_routes.dart';

class AudioDetailController extends GetxController {
  late AudioStoryModel story;
  final RxBool showFullDescription = false.obs;

  final List<AudioStoryModel> moreLikeThis = _generateMoreLikeThis();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is AudioStoryModel) {
      story = Get.arguments as AudioStoryModel;
    } else {
      story = _fallbackStory();
    }
  }

  void toggleDescription() {
    showFullDescription.value = !showFullDescription.value;
  }

  void onPlayNow() {
    Get.toNamed(AppRoutes.audioPlayer, arguments: story);
  }

  void onMoreLikeThisTap(AudioStoryModel s) {
    Get.toNamed(AppRoutes.audioDetail, arguments: s);
  }
}

AudioStoryModel _fallbackStory() {
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
  return AudioStoryModel(
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
  );
}

List<AudioStoryModel> _generateMoreLikeThis() {
  return List.generate(
    6,
    (i) => AudioStoryModel(
      id: 'more_$i',
      title: 'Story ${i + 1}',
      subtitle: 'Subtitle ${i + 1}',
      imageUrl: 'https://picsum.photos/seed/more${i + 1}/200/300',
      genre: 'Action',
      rating: 4.0 + (i * 0.1),
      totalEpisodes: 10 + i,
      duration: '${3 + i}h 00m',
      totalPlays: 1000 * (i + 1),
      description: 'Description for story ${i + 1}',
      episodes: [],
    ),
  );
}
