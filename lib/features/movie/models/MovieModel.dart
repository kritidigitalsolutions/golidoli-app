bool _parseBool(dynamic val) {
  if (val == null) return false;
  if (val is bool) return val;
  if (val is num) return val == 1;
  if (val is String) {
    final s = val.trim().toLowerCase();
    return s == 'true' || s == '1' || s == 'yes';
  }
  return false;
}

class MovieModel {
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
  final DateTime? releaseDate;
  final int priority;
  final String videoUrl;
  final String trailerUrl;
  final bool isPremium;
  final double rating;
  final bool isPopular;
  final List<dynamic> cast;
  final List<dynamic> category;
  final int likes;
  final int dislikes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String slug;

  const MovieModel({
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
    required this.releaseDate,
    required this.priority,
    required this.videoUrl,
    required this.trailerUrl,
    required this.isPremium,
    required this.rating,
    this.isPopular = false,
    required this.cast,
    required this.category,
    this.likes = 0,
    this.dislikes = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
  });

  MovieModel copyWith({
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
    DateTime? releaseDate,
    int? priority,
    String? videoUrl,
    String? trailerUrl,
    bool? isPremium,
    double? rating,
    bool? isPopular,
    List<dynamic>? cast,
    List<dynamic>? category,
    int? likes,
    int? dislikes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? slug,
  }) {
    return MovieModel(
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
      priority: priority ?? this.priority,
      videoUrl: videoUrl ?? this.videoUrl,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      isPremium: isPremium ?? this.isPremium,
      rating: rating ?? this.rating,
      isPopular: isPopular ?? this.isPopular,
      cast: cast ?? this.cast,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slug: slug ?? this.slug,
    );
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      releaseYear: json['releaseYear'] ?? 0,
      duration: json['duration'] ?? '',
      language: json['language'] ?? '',
      poster: json['poster'] ?? '',
      banner: json['banner'] ?? '',
      isComingSoon: _parseBool(
        json['isComingSoon'] ?? json['is_coming_soon'] ?? json['comingSoon'],
      ),
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'].toString())
          : null,
      priority: (json['priority'] is num)
          ? (json['priority'] as num).toInt()
          : int.tryParse(json['priority']?.toString() ?? '0') ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
      isPremium: _parseBool(
        json['isPremium'] ??
            json['is_premium'] ??
            json['premium'] ??
            json['isPremimu'],
      ),
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      isPopular: _parseBool(
        json['isPopular'] ??
            json['popularMovie'] ??
            json['isPopularMovie'] ??
            json['is_popular'],
      ),
      cast: List<dynamic>.from(json['cast'] ?? []),
      category: List<dynamic>.from(json['category'] ?? []),
      likes: (json['likes'] is num)
          ? (json['likes'] as num).toInt()
          : (json['likes'] is List
              ? (json['likes'] as List).length
              : int.tryParse(json['likes']?.toString() ?? '0') ?? 0),
      dislikes: (json['dislikes'] is num)
          ? (json['dislikes'] as num).toInt()
          : (json['dislikes'] is List
              ? (json['dislikes'] as List).length
              : int.tryParse(json['dislikes']?.toString() ?? '0') ?? 0),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      slug: json['slug'] ?? '',
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
      'releaseDate': releaseDate?.toIso8601String(),
      'priority': priority,
      'videoUrl': videoUrl,
      'trailerUrl': trailerUrl,
      'isPremium': isPremium,
      'rating': rating,
      'isPopular': isPopular,
      'cast': cast,
      'category': category,
      'likes': likes,
      'dislikes': dislikes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'slug': slug,
    };
  }
}
