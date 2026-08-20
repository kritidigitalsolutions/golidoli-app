class MicroDramaEpisodesResponse {
  final bool success;
  final List<MicroDramaEpisode> episodes;

  const MicroDramaEpisodesResponse({
    required this.success,
    required this.episodes,
  });

  factory MicroDramaEpisodesResponse.fromJson(Map<String, dynamic> json) {
    return MicroDramaEpisodesResponse(
      success: json['success'] ?? false,
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => MicroDramaEpisode.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }

  MicroDramaEpisodesResponse copyWith({
    bool? success,
    List<MicroDramaEpisode>? episodes,
  }) {
    return MicroDramaEpisodesResponse(
      success: success ?? this.success,
      episodes: episodes ?? this.episodes,
    );
  }
}

class MicroDramaEpisode {
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

  const MicroDramaEpisode({
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

  factory MicroDramaEpisode.fromJson(Map<String, dynamic> json) {
    return MicroDramaEpisode(
      id: json['_id'] ?? '',
      tvShowId: json['tvShowId'] ?? '',
      episodeNumber: (json['episodeNumber'] is num)
          ? (json['episodeNumber'] as num).toInt()
          : int.tryParse(json['episodeNumber']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
      isLocked: json['isLocked'] ?? false,
      isVertical: json['isVertical'] ?? false,
      views: (json['views'] is num) ? (json['views'] as num).toInt() : 0,
      likes: (json['likes'] is num) ? (json['likes'] as num).toInt() : 0,
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

  MicroDramaEpisode copyWith({
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
    return MicroDramaEpisode(
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