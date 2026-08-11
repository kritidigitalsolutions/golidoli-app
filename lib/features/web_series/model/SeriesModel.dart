class SeriesResponse {
  final bool success;
  final List<Series> series;

  const SeriesResponse({required this.success, required this.series});

  factory SeriesResponse.fromJson(Map<String, dynamic> json) {
    return SeriesResponse(
      success: json['success'] ?? false,
      series:
          (json['series'] as List<dynamic>?)
              ?.map((e) => Series.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'series': series.map((e) => e.toJson()).toList(),
    };
  }

  SeriesResponse copyWith({bool? success, List<Series>? series}) {
    return SeriesResponse(
      success: success ?? this.success,
      series: series ?? this.series,
    );
  }
}

class Series {
  final String id;
  final String title;
  final String description;
  final List<String> genre;
  final int releaseYear;
  final String duration;
  final String language;
  final String poster;
  final String banner;
  final bool isComingSoon;
  final String? releaseDate;
  final String trailerUrl;
  final bool isPremium;
  final int priority;
  final double rating;
  final List<dynamic> cast;
  final List<dynamic> category;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final int totalSeasons;
  final int totalEpisodes;
  final String createdAt;
  final String updatedAt;
  final String slug;
  final int v;
  final List<dynamic> seasons;

  const Series({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.releaseYear,
    required this.duration,
    required this.language,
    required this.poster,
    required this.banner,
    required this.isComingSoon,
    this.releaseDate,
    required this.trailerUrl,
    required this.isPremium,
    required this.priority,
    required this.rating,
    required this.cast,
    required this.category,
    required this.likes,
    required this.dislikes,
    required this.totalSeasons,
    required this.totalEpisodes,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.v,
    required this.seasons,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      releaseYear: json['releaseYear'] ?? 0,
      duration: json['duration'] ?? '',
      language: json['language'] ?? '',
      poster: json['poster'] ?? '',
      banner: json['banner'] ?? '',
      isComingSoon: json['isComingSoon'] ?? false,
      releaseDate: json['releaseDate'],
      trailerUrl: json['trailerUrl'] ?? '',
      isPremium: json['isPremium'] ?? false,
      priority: json['priority'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      cast: List<dynamic>.from(json['cast'] ?? []),
      category: List<dynamic>.from(json['category'] ?? []),
      likes: List<dynamic>.from(json['likes'] ?? []),
      dislikes: List<dynamic>.from(json['dislikes'] ?? []),
      totalSeasons: json['totalSeasons'] ?? 0,
      totalEpisodes: json['totalEpisodes'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      slug: json['slug'] ?? '',
      v: json['__v'] ?? 0,
      seasons: List<dynamic>.from(json['seasons'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'genre': genre,
      'releaseYear': releaseYear,
      'duration': duration,
      'language': language,
      'poster': poster,
      'banner': banner,
      'isComingSoon': isComingSoon,
      'releaseDate': releaseDate,
      'trailerUrl': trailerUrl,
      'isPremium': isPremium,
      'priority': priority,
      'rating': rating,
      'cast': cast,
      'category': category,
      'likes': likes,
      'dislikes': dislikes,
      'totalSeasons': totalSeasons,
      'totalEpisodes': totalEpisodes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'slug': slug,
      '__v': v,
      'seasons': seasons,
    };
  }

  Series copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? genre,
    int? releaseYear,
    String? duration,
    String? language,
    String? poster,
    String? banner,
    bool? isComingSoon,
    String? releaseDate,
    String? trailerUrl,
    bool? isPremium,
    int? priority,
    double? rating,
    List<dynamic>? cast,
    List<dynamic>? category,
    List<dynamic>? likes,
    List<dynamic>? dislikes,
    int? totalSeasons,
    int? totalEpisodes,
    String? createdAt,
    String? updatedAt,
    String? slug,
    int? v,
    List<dynamic>? seasons,
  }) {
    return Series(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      releaseYear: releaseYear ?? this.releaseYear,
      duration: duration ?? this.duration,
      language: language ?? this.language,
      poster: poster ?? this.poster,
      banner: banner ?? this.banner,
      isComingSoon: isComingSoon ?? this.isComingSoon,
      releaseDate: releaseDate ?? this.releaseDate,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      isPremium: isPremium ?? this.isPremium,
      priority: priority ?? this.priority,
      rating: rating ?? this.rating,
      cast: cast ?? this.cast,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      totalSeasons: totalSeasons ?? this.totalSeasons,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slug: slug ?? this.slug,
      v: v ?? this.v,
      seasons: seasons ?? this.seasons,
    );
  }
}
