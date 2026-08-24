import 'package:golidoli_app/utils/helpers.dart';

class AudioCategoryModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;

  const AudioCategoryModel({
    required this.id,
    required this.name,
    this.description = '',
    this.isActive = true,
  });

  factory AudioCategoryModel.fromJson(Map<String, dynamic> json) {
    return AudioCategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'isActive': isActive,
      };
}

class AudioEpisodeModel {
  final String id;
  final String title;
  final String storyId;
  final String storyTitle;
  final String storyCoverImage;
  final int episodeNumber;
  final int durationSeconds;
  final String audioUrl;
  final String fileSize;
  final String coverImage;
  final bool isPremium;
  final int progressSeconds;
  final bool isCompleted;
  final bool isPlaying;

  const AudioEpisodeModel({
    required this.id,
    required this.title,
    this.storyId = '',
    this.storyTitle = '',
    this.storyCoverImage = '',
    this.episodeNumber = 1,
    this.durationSeconds = 0,
    this.audioUrl = '',
    this.fileSize = '',
    this.coverImage = '',
    this.isPremium = false,
    this.progressSeconds = 0,
    this.isCompleted = false,
    this.isPlaying = false,
  });

  Duration get duration => Duration(seconds: durationSeconds);

  String get imageUrl => formatMediaUrl(
        coverImage.isNotEmpty ? coverImage : storyCoverImage,
      );

  String get playableAudioUrl => formatMediaUrl(audioUrl);

  factory AudioEpisodeModel.fromJson(
    Map<String, dynamic> json, {
    String parentStoryId = '',
    String parentStoryTitle = '',
    String parentStoryCover = '',
  }) {
    String resolvedStoryId = parentStoryId;
    String resolvedStoryTitle = parentStoryTitle;
    String resolvedStoryCover = parentStoryCover;

    if (json['storyId'] is Map) {
      final s = json['storyId'] as Map<String, dynamic>;
      resolvedStoryId = s['_id']?.toString() ?? s['id']?.toString() ?? resolvedStoryId;
      resolvedStoryTitle = s['title']?.toString() ?? resolvedStoryTitle;
      resolvedStoryCover = s['coverImage']?.toString() ??
          s['bannerImage']?.toString() ??
          resolvedStoryCover;
    } else if (json['storyId'] is String) {
      resolvedStoryId = json['storyId'].toString();
    }

    final rawDuration = json['duration'] ?? json['durationSeconds'];
    int parsedDuration = 0;
    if (rawDuration is int) {
      parsedDuration = rawDuration;
    } else if (rawDuration is double) {
      parsedDuration = rawDuration.toInt();
    } else if (rawDuration is String) {
      parsedDuration = int.tryParse(rawDuration) ?? 0;
    }

    final rawProgress = json['progressSeconds'] ?? 0;
    int parsedProgress = 0;
    if (rawProgress is int) {
      parsedProgress = rawProgress;
    } else if (rawProgress is double) {
      parsedProgress = rawProgress.toInt();
    } else if (rawProgress is String) {
      parsedProgress = int.tryParse(rawProgress) ?? 0;
    }

    return AudioEpisodeModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Episode ${json['episodeNumber'] ?? 1}',
      storyId: resolvedStoryId,
      storyTitle: resolvedStoryTitle,
      storyCoverImage: resolvedStoryCover,
      episodeNumber: json['episodeNumber'] is int
          ? json['episodeNumber']
          : int.tryParse(json['episodeNumber']?.toString() ?? '1') ?? 1,
      durationSeconds: parsedDuration,
      audioUrl: json['audioUrl']?.toString() ?? json['fileUrl']?.toString() ?? '',
      fileSize: json['fileSize']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ??
          json['thumbnail']?.toString() ??
          json['imageUrl']?.toString() ??
          '',
      isPremium: json['isPremium'] == true,
      progressSeconds: parsedProgress,
      isCompleted: json['isCompleted'] == true,
      isPlaying: false,
    );
  }

  AudioEpisodeModel copyWith({
    String? id,
    String? title,
    String? storyId,
    String? storyTitle,
    String? storyCoverImage,
    int? episodeNumber,
    int? durationSeconds,
    String? audioUrl,
    String? fileSize,
    String? coverImage,
    bool? isPremium,
    int? progressSeconds,
    bool? isCompleted,
    bool? isPlaying,
  }) {
    return AudioEpisodeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      storyId: storyId ?? this.storyId,
      storyTitle: storyTitle ?? this.storyTitle,
      storyCoverImage: storyCoverImage ?? this.storyCoverImage,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      audioUrl: audioUrl ?? this.audioUrl,
      fileSize: fileSize ?? this.fileSize,
      coverImage: coverImage ?? this.coverImage,
      isPremium: isPremium ?? this.isPremium,
      progressSeconds: progressSeconds ?? this.progressSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'storyId': storyId,
        'storyTitle': storyTitle,
        'episodeNumber': episodeNumber,
        'duration': durationSeconds,
        'audioUrl': audioUrl,
        'fileSize': fileSize,
        'coverImage': coverImage,
        'isPremium': isPremium,
      };
}

class AudioStoryModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String coverImage;
  final String bannerImage;
  final String categoryId;
  final String genre;
  final String language;
  final double rating;
  final int totalEpisodes;
  final String duration;
  final int totalPlays;
  final String status;
  final bool isPremium;
  final List<AudioEpisodeModel> episodes;

  const AudioStoryModel({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.description = '',
    this.coverImage = '',
    this.bannerImage = '',
    this.categoryId = '',
    this.genre = 'Audio Story',
    this.language = 'Hindi',
    this.rating = 4.5,
    this.totalEpisodes = 0,
    this.duration = '',
    this.totalPlays = 0,
    this.status = 'Published',
    this.isPremium = false,
    this.episodes = const [],
  });

  String get imageUrl => formatMediaUrl(
        coverImage.isNotEmpty
            ? coverImage
            : (bannerImage.isNotEmpty ? bannerImage : ''),
      );

  String get bannerUrl => formatMediaUrl(
        bannerImage.isNotEmpty
            ? bannerImage
            : (coverImage.isNotEmpty ? coverImage : ''),
      );

  factory AudioStoryModel.fromJson(Map<String, dynamic> json) {
    String parsedGenre = 'Audio Story';
    String parsedCategoryId = '';
    if (json['category'] is Map) {
      final cat = json['category'] as Map<String, dynamic>;
      parsedGenre = cat['name']?.toString() ?? 'Audio Story';
      parsedCategoryId = cat['_id']?.toString() ?? cat['id']?.toString() ?? '';
    } else if (json['category'] is String) {
      parsedGenre = json['category'].toString();
      parsedCategoryId = json['categoryId']?.toString() ?? '';
    } else if (json['genre'] != null) {
      parsedGenre = json['genre'].toString();
    }

    final storyId = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    final storyTitle = json['title']?.toString() ?? '';
    final rawCover = json['coverImage']?.toString() ?? json['imageUrl']?.toString() ?? '';
    final rawBanner = json['bannerImage']?.toString() ?? '';

    List<AudioEpisodeModel> parsedEpisodes = [];
    if (json['episodes'] is List) {
      parsedEpisodes = (json['episodes'] as List)
          .map((e) => AudioEpisodeModel.fromJson(
                Map<String, dynamic>.from(e),
                parentStoryId: storyId,
                parentStoryTitle: storyTitle,
                parentStoryCover: rawCover,
              ))
          .toList();
    }

    final rawRating = json['rating'] ?? json['averageRating'];
    double parsedRating = 4.5;
    if (rawRating is num) {
      parsedRating = rawRating.toDouble();
    } else if (rawRating is String) {
      parsedRating = double.tryParse(rawRating) ?? 4.5;
    }

    final rawPlays = json['totalPlays'] ?? json['plays'] ?? json['views'] ?? 0;
    int parsedPlays = 0;
    if (rawPlays is int) {
      parsedPlays = rawPlays;
    } else if (rawPlays is double) {
      parsedPlays = rawPlays.toInt();
    } else if (rawPlays is String) {
      parsedPlays = int.tryParse(rawPlays) ?? 0;
    }

    final int epCount = parsedEpisodes.isNotEmpty
        ? parsedEpisodes.length
        : (json['totalEpisodes'] is int
            ? json['totalEpisodes']
            : int.tryParse(json['totalEpisodes']?.toString() ?? '0') ?? 0);

    return AudioStoryModel(
      id: storyId,
      title: storyTitle,
      subtitle: json['subtitle']?.toString() ??
          json['tagline']?.toString() ??
          (parsedGenre.isNotEmpty ? parsedGenre : 'Audio Story'),
      description: json['description']?.toString() ?? '',
      coverImage: rawCover,
      bannerImage: rawBanner,
      categoryId: parsedCategoryId,
      genre: parsedGenre,
      language: json['language']?.toString() ?? 'Hindi',
      rating: parsedRating,
      totalEpisodes: epCount,
      duration: json['duration']?.toString() ??
          (epCount > 0 ? '$epCount Episodes' : ''),
      totalPlays: parsedPlays,
      status: json['status']?.toString() ?? 'Published',
      isPremium: json['isPremium'] == true,
      episodes: parsedEpisodes,
    );
  }

  AudioStoryModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? coverImage,
    String? bannerImage,
    String? categoryId,
    String? genre,
    String? language,
    double? rating,
    int? totalEpisodes,
    String? duration,
    int? totalPlays,
    String? status,
    bool? isPremium,
    List<AudioEpisodeModel>? episodes,
  }) {
    return AudioStoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      bannerImage: bannerImage ?? this.bannerImage,
      categoryId: categoryId ?? this.categoryId,
      genre: genre ?? this.genre,
      language: language ?? this.language,
      rating: rating ?? this.rating,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      duration: duration ?? this.duration,
      totalPlays: totalPlays ?? this.totalPlays,
      status: status ?? this.status,
      isPremium: isPremium ?? this.isPremium,
      episodes: episodes ?? this.episodes,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'coverImage': coverImage,
        'bannerImage': bannerImage,
        'category': genre,
        'language': language,
        'rating': rating,
        'totalEpisodes': totalEpisodes,
        'duration': duration,
        'totalPlays': totalPlays,
        'status': status,
        'isPremium': isPremium,
        'episodes': episodes.map((e) => e.toJson()).toList(),
      };
}

class AudioProgressModel {
  final String id;
  final String episodeId;
  final int progressSeconds;
  final int durationSeconds;
  final bool isCompleted;
  final AudioEpisodeModel? episode;

  const AudioProgressModel({
    required this.id,
    required this.episodeId,
    required this.progressSeconds,
    required this.durationSeconds,
    required this.isCompleted,
    this.episode,
  });

  double get progressPercentage => durationSeconds > 0
      ? (progressSeconds / durationSeconds).clamp(0.0, 1.0)
      : 0.0;

  factory AudioProgressModel.fromJson(Map<String, dynamic> json) {
    AudioEpisodeModel? parsedEpisode;
    String epId = json['episodeId']?.toString() ?? '';

    if (json['episode'] is Map) {
      parsedEpisode = AudioEpisodeModel.fromJson(
        Map<String, dynamic>.from(json['episode']),
      );
      epId = parsedEpisode.id;
    } else if (json['episodeId'] is Map) {
      parsedEpisode = AudioEpisodeModel.fromJson(
        Map<String, dynamic>.from(json['episodeId']),
      );
      epId = parsedEpisode.id;
    }

    final rawProg = json['progressSeconds'] ?? json['progress'] ?? 0;
    final rawDur = json['durationSeconds'] ?? json['duration'] ?? 0;

    return AudioProgressModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      episodeId: epId,
      progressSeconds: rawProg is int ? rawProg : (int.tryParse(rawProg.toString()) ?? 0),
      durationSeconds: rawDur is int ? rawDur : (int.tryParse(rawDur.toString()) ?? 0),
      isCompleted: json['isCompleted'] == true,
      episode: parsedEpisode,
    );
  }
}

class AudioHomeFeedModel {
  final List<AudioStoryModel> featured;
  final List<AudioStoryModel> recentlyAdded;
  final List<AudioStoryModel> topRated;

  const AudioHomeFeedModel({
    this.featured = const [],
    this.recentlyAdded = const [],
    this.topRated = const [],
  });

  factory AudioHomeFeedModel.fromJson(Map<String, dynamic> json) {
    List<AudioStoryModel> parseList(dynamic raw) {
      if (raw is List) {
        return raw
            .map((e) => AudioStoryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    }

    return AudioHomeFeedModel(
      featured: parseList(json['featured'] ?? json['banners']),
      recentlyAdded: parseList(json['recentlyAdded'] ?? json['latest']),
      topRated: parseList(json['topRated'] ?? json['popular'] ?? json['trending']),
    );
  }
}
