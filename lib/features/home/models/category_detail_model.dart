import 'package:equatable/equatable.dart';

class CategoryContentResponse extends Equatable {
  final bool success;
  final Category category;
  final List<ContentModel> content;

  const CategoryContentResponse({
    required this.success,
    required this.category,
    required this.content,
  });

  factory CategoryContentResponse.fromJson(Map<String, dynamic> json) {
    return CategoryContentResponse(
      success: json['success'] ?? false,
      category: Category.fromJson(json['category'] ?? {}),
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => ContentModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'category': category.toJson(),
      'content': content.map((e) => e.toJson()).toList(),
    };
  }

  CategoryContentResponse copyWith({
    bool? success,
    Category? category,
    List<ContentModel>? content,
  }) {
    return CategoryContentResponse(
      success: success ?? this.success,
      category: category ?? this.category,
      content: content ?? this.content,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [success, category, content];
}

class Category extends Equatable {
  final String id;
  final String name;
  final String slug;
  final int priority;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int version;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.priority,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      priority: json['priority'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'priority': priority,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? slug,
    int? priority,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    int? version,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    name,
    slug,
    priority,
    isActive,
    createdAt,
    updatedAt,
    version,
  ];
}

class ContentModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> genre;
  final int? releaseYear;
  final String duration;
  final String language;
  final String poster;
  final String banner;
  final bool isComingSoon;
  final String? releaseDate;
  final int priority;
  final bool isPremium;
  final num rating;
  final List<dynamic> cast;
  final List<String> category;
  final List<dynamic> likes;
  final List<dynamic> dislikes;
  final String createdAt;
  final String updatedAt;
  final String slug;
  final bool isPublished;
  final String type;

  const ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    this.releaseYear,
    required this.duration,
    required this.language,
    required this.poster,
    required this.banner,
    required this.isComingSoon,
    this.releaseDate,
    required this.priority,
    required this.isPremium,
    required this.rating,
    required this.cast,
    required this.category,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.isPublished,
    required this.type,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      genre: List<String>.from(json['genre'] ?? []),
      releaseYear: json['releaseYear'],
      duration: json['duration'] ?? '',
      language: json['language'] ?? '',
      poster: json['poster'] ?? '',
      banner: json['banner'] ?? '',
      isComingSoon: json['isComingSoon'] ?? false,
      releaseDate: json['releaseDate'],
      priority: json['priority'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      rating: json['rating'] ?? 0,
      cast: List<dynamic>.from(json['cast'] ?? []),
      category: List<String>.from(json['category'] ?? []),
      likes: List<dynamic>.from(json['likes'] ?? []),
      dislikes: List<dynamic>.from(json['dislikes'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      slug: json['slug'] ?? '',
      isPublished: json['isPublished'] ?? false,
      type: json['type'] ?? '',
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
      'priority': priority,
      'isPremium': isPremium,
      'rating': rating,
      'cast': cast,
      'category': category,
      'likes': likes,
      'dislikes': dislikes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'slug': slug,
      'isPublished': isPublished,
      'type': type,
    };
  }

  ContentModel copyWith({
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
    int? priority,
    bool? isPremium,
    num? rating,
    List<dynamic>? cast,
    List<String>? category,
    List<dynamic>? likes,
    List<dynamic>? dislikes,
    String? createdAt,
    String? updatedAt,
    String? slug,
    bool? isPublished,
    String? type,
  }) {
    return ContentModel(
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
      isPremium: isPremium ?? this.isPremium,
      rating: rating ?? this.rating,
      cast: cast ?? this.cast,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slug: slug ?? this.slug,
      isPublished: isPublished ?? this.isPublished,
      type: type ?? this.type,
    );
  }

  @override
  // TODO: implement props
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
    isPremium,
    rating,
    cast,
    category,
    likes,
    dislikes,
    createdAt,
    updatedAt,
    slug,
    isPublished,
    type,
  ];
}
