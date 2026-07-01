class MicroDramaModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String genre;
  final double rating;
  final int totalReviews;
  final int totalEpisodes;
  final List<String> tags;
  final String story;
  final bool isPremium;
  final int likes;
  final int comments;
  final int shares;

  const MicroDramaModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.genre,
    required this.rating,
    required this.totalReviews,
    required this.totalEpisodes,
    required this.tags,
    required this.story,
    this.isPremium = false,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
  });
}

class MicroDramaEpisodeModel {
  final String id;
  final int episodeNumber;
  final String title;
  final bool isLocked;

  const MicroDramaEpisodeModel({
    required this.id,
    required this.episodeNumber,
    required this.title,
    this.isLocked = false,
  });
}
