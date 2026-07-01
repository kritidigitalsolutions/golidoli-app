class AudioStoryModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String genre;
  final double rating;
  final int totalEpisodes;
  final String duration;
  final int totalPlays;
  final String description;
  final List<AudioEpisodeModel> episodes;

  const AudioStoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.genre,
    required this.rating,
    required this.totalEpisodes,
    required this.duration,
    required this.totalPlays,
    required this.description,
    required this.episodes,
  });
}

class AudioEpisodeModel {
  final String id;
  final String title;
  final String storyTitle;
  final int episodeNumber;
  final String fileSize;
  final String imageUrl;
  final Duration duration;
  final bool isPlaying;

  const AudioEpisodeModel({
    required this.id,
    required this.title,
    required this.storyTitle,
    required this.episodeNumber,
    required this.fileSize,
    required this.imageUrl,
    required this.duration,
    this.isPlaying = false,
  });
}
