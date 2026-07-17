import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
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
  final int rating;
  final List<dynamic> cast;
  final List<dynamic> category;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
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
    required this.cast,
    required this.category,
    required this.likes,
    required this.dislikes,
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
    int? rating,
    List<dynamic>? cast,
    List<dynamic>? category,
    List<dynamic>? likes,
    List<dynamic>? dislikes,
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
      isComingSoon: json['isComingSoon'] ?? false,
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      priority: json['priority'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
      isPremium: json['isPremium'] ?? false,
      rating: json['rating'] ?? 0,
      cast: List<dynamic>.from(json['cast'] ?? []),
      category: List<dynamic>.from(json['category'] ?? []),
      likes: List<dynamic>.from(json['likes'] ?? []),
      dislikes: List<dynamic>.from(json['dislikes'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'cast': cast,
      'category': category,
      'likes': likes,
      'dislikes': dislikes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'slug': slug,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    genre,
    releaseYear,
    duration,
    language,
    poster,
    banner,
    isComingSoon,
    releaseDate,
    priority,
    videoUrl,
    trailerUrl,
    isPremium,
    rating,
    cast,
    category,
    likes,
    dislikes,
    createdAt,
    updatedAt,
    slug,
  ];
}
