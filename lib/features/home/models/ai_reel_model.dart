import 'package:golidoli_app/constants/app_url.dart';

class AiReelModel {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final String duration;
  final int views;
  final int likes;
  final int shares;
  final bool isPublished;
  final int priority;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;

  AiReelModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.views,
    required this.likes,
    this.shares = 0,
    this.isPublished = true,
    this.priority = 0,
    this.publishedAt = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory AiReelModel.fromJson(Map<String, dynamic> json) {
    int parsedLikes = 0;
    if (json['like'] != null) {
      if (json['like'] is num) {
        parsedLikes = (json['like'] as num).toInt();
      } else if (json['like'] is String) {
        parsedLikes = int.tryParse(json['like'] as String) ?? 0;
      }
    } else if (json['likes'] != null) {
      if (json['likes'] is num) {
        parsedLikes = (json['likes'] as num).toInt();
      } else if (json['likes'] is List) {
        parsedLikes = (json['likes'] as List).length;
      } else if (json['likes'] is String) {
        parsedLikes = int.tryParse(json['likes'] as String) ?? 0;
      }
    }

    int parsedViews = 0;
    if (json['views'] != null) {
      if (json['views'] is num) {
        parsedViews = (json['views'] as num).toInt();
      } else if (json['views'] is String) {
        parsedViews = int.tryParse(json['views'] as String) ?? 0;
      }
    }

    int parsedShares = 0;
    if (json['shares'] != null) {
      if (json['shares'] is num) {
        parsedShares = (json['shares'] as num).toInt();
      } else if (json['shares'] is String) {
        parsedShares = int.tryParse(json['shares'] as String) ?? 0;
      }
    } else if (json['share'] != null) {
      if (json['share'] is num) {
        parsedShares = (json['share'] as num).toInt();
      } else if (json['share'] is String) {
        parsedShares = int.tryParse(json['share'] as String) ?? 0;
      }
    }

    int parsedPriority = 0;
    if (json['priority'] != null) {
      if (json['priority'] is num) {
        parsedPriority = (json['priority'] as num).toInt();
      } else if (json['priority'] is String) {
        parsedPriority = int.tryParse(json['priority'] as String) ?? 0;
      }
    }

    return AiReelModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? json['story'] ?? '').toString(),
      thumbnail: (json['thumbnail'] ?? json['imageUrl'] ?? '').toString(),
      videoUrl: (json['videoUrl'] ?? '').toString(),
      duration: (json['duration'] ?? '').toString(),
      views: parsedViews,
      likes: parsedLikes,
      shares: parsedShares,
      isPublished: json['isPublished'] == true,
      priority: parsedPriority,
      publishedAt: (json['publishedAt'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'duration': duration,
      'views': views,
      'like': likes,
      'shares': shares,
      'isPublished': isPublished,
      'priority': priority,
      'publishedAt': publishedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Full streamable / playable video URL
  String get fullVideoUrl {
    if (videoUrl.isEmpty) return '';
    if (videoUrl.startsWith('http://') || videoUrl.startsWith('https://')) {
      return videoUrl;
    }
    final cleanPath = videoUrl.startsWith('/') ? videoUrl : '/$videoUrl';
    return '${AppUrl.baseUrl}$cleanPath';
  }

  /// Full image / poster URL
  String get fullThumbnailUrl {
    if (thumbnail.isEmpty) return '';
    if (thumbnail.startsWith('http://') || thumbnail.startsWith('https://')) {
      return thumbnail;
    }
    final cleanPath = thumbnail.startsWith('/') ? thumbnail : '/$thumbnail';
    return '${AppUrl.baseUrl}$cleanPath';
  }
}

class AiReelsPagination {
  final int limit;
  final String sessionId;
  final bool hasMore;

  AiReelsPagination({
    this.limit = 10,
    this.sessionId = '',
    this.hasMore = false,
  });

  factory AiReelsPagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AiReelsPagination();
    return AiReelsPagination(
      limit: (json['limit'] is num) ? (json['limit'] as num).toInt() : 10,
      sessionId: (json['sessionId'] ?? '').toString(),
      hasMore: json['hasMore'] == true,
    );
  }
}

class AiReelsMeta {
  final String feedType;
  final String mode;
  final bool allWatched;
  final bool hasUnwatched;
  final bool replayAvailable;
  final bool replayEnabled;
  final int totalPublished;
  final int watchedPublished;

  AiReelsMeta({
    this.feedType = 'trending',
    this.mode = 'fresh',
    this.allWatched = false,
    this.hasUnwatched = true,
    this.replayAvailable = false,
    this.replayEnabled = false,
    this.totalPublished = 0,
    this.watchedPublished = 0,
  });

  factory AiReelsMeta.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AiReelsMeta();
    return AiReelsMeta(
      feedType: (json['feedType'] ?? 'trending').toString(),
      mode: (json['mode'] ?? 'fresh').toString(),
      allWatched: json['allWatched'] == true,
      hasUnwatched: json['hasUnwatched'] != false,
      replayAvailable: json['replayAvailable'] == true,
      replayEnabled: json['replayEnabled'] == true,
      totalPublished: (json['totalPublished'] is num)
          ? (json['totalPublished'] as num).toInt()
          : 0,
      watchedPublished: (json['watchedPublished'] is num)
          ? (json['watchedPublished'] as num).toInt()
          : 0,
    );
  }
}

class AiReelsResponse {
  final bool success;
  final String message;
  final List<AiReelModel> data;
  final AiReelsPagination pagination;
  final AiReelsMeta meta;

  AiReelsResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
    required this.meta,
  });

  factory AiReelsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<AiReelModel> parsedList = [];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          parsedList.add(AiReelModel.fromJson(item));
        }
      }
    }

    return AiReelsResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      data: parsedList,
      pagination: AiReelsPagination.fromJson(
        json['pagination'] as Map<String, dynamic>?,
      ),
      meta: AiReelsMeta.fromJson(json['meta'] as Map<String, dynamic>?),
    );
  }
}

class AiReelShareResponse {
  final bool success;
  final String message;
  final String aiReelId;
  final int shares;

  AiReelShareResponse({
    required this.success,
    required this.message,
    required this.aiReelId,
    required this.shares,
  });

  factory AiReelShareResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    int parsedShares = 0;
    String parsedId = '';
    if (data != null) {
      parsedId = (data['aiReelId'] ?? data['_id'] ?? data['id'] ?? '').toString();
      if (data['shares'] != null) {
        if (data['shares'] is num) {
          parsedShares = (data['shares'] as num).toInt();
        } else if (data['shares'] is String) {
          parsedShares = int.tryParse(data['shares'] as String) ?? 0;
        }
      }
    }
    return AiReelShareResponse(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      aiReelId: parsedId,
      shares: parsedShares,
    );
  }
}
