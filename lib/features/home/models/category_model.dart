class CategoriesResponse {
  final bool success;
  final List<CategoryModel> categories;

  const CategoriesResponse({
    required this.success,
    required this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      success: json['success'] ?? false,
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }

  CategoriesResponse copyWith({
    bool? success,
    List<CategoryModel>? categories,
  }) {
    return CategoriesResponse(
      success: success ?? this.success,
      categories: categories ?? this.categories,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final int priority;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final int version;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.priority,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
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

  CategoryModel copyWith({
    String? id,
    String? name,
    String? slug,
    int? priority,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    int? version,
  }) {
    return CategoryModel(
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
}