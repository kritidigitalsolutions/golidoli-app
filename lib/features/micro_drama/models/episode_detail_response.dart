class EpisodesResponse {
  final bool success;
  final List<EpisodeModel> episodes;

  const EpisodesResponse({
    required this.success,
    required this.episodes,
  });

  factory EpisodesResponse.fromJson(Map<String, dynamic> json) {
    return EpisodesResponse(
      success: json['success'] ?? false,
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => EpisodeModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }

  EpisodesResponse copyWith({
    bool? success,
    List<EpisodeModel>? episodes,
  }) {
    return EpisodesResponse(
      success: success ?? this.success,
      episodes: episodes ?? this.episodes,
    );
  }
}

class EpisodeModel {
  final String id;
  final String tvShowId;
  final int episodeNumber;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnail;
  final String duration;
  final bool isLocked;
  final bool isVertical;
  final int views;
  final int likes;
  final String createdAt;
  final String updatedAt;
  final int version;

  const EpisodeModel({
    required this.id,
    required this.tvShowId,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnail,
    required this.duration,
    required this.isLocked,
    required this.isVertical,
    required this.views,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['_id'] ?? '',
      tvShowId: json['tvShowId'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
      isLocked: json['isLocked'] ?? false,
      isVertical: json['isVertical'] ?? false,
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tvShowId': tvShowId,
      'episodeNumber': episodeNumber,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'duration': duration,
      'isLocked': isLocked,
      'isVertical': isVertical,
      'views': views,
      'likes': likes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }

  EpisodeModel copyWith({
    String? id,
    String? tvShowId,
    int? episodeNumber,
    String? title,
    String? description,
    String? videoUrl,
    String? thumbnail,
    String? duration,
    bool? isLocked,
    bool? isVertical,
    int? views,
    int? likes,
    String? createdAt,
    String? updatedAt,
    int? version,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      tvShowId: tvShowId ?? this.tvShowId,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      duration: duration ?? this.duration,
      isLocked: isLocked ?? this.isLocked,
      isVertical: isVertical ?? this.isVertical,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}