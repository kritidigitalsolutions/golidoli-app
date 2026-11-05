class HomeBannerResponse {
  final bool? success;
  final int? count;
  final List<HomeBannerItem>? data;

  HomeBannerResponse({this.success, this.count, this.data});

  factory HomeBannerResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List?;
    final items = rawData != null
        ? rawData
            .map((i) => HomeBannerItem.fromJson(i))
            .where((b) => b.isVisible)
            .toList()
        : <HomeBannerItem>[];
    return HomeBannerResponse(
      success: json['success'],
      count: json['count'],
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class HomeBannerItem {
  final String? id;
  final String? title;
  final String? banner;
  final String? contentType;
  final int? order;
  final bool? isActive;
  final bool? isHide;
  final HomeBannerContent? content;
  final String? createdAt;

  bool get isVisible {
    if (isActive == false) return false;
    if (isHide == true) return false;
    if (content != null && content!.isVisible == false) return false;
    return true;
  }

  HomeBannerItem({
    this.id,
    this.title,
    this.banner,
    this.contentType,
    this.order,
    this.isActive,
    this.isHide,
    this.content,
    this.createdAt,
  });

  factory HomeBannerItem.fromJson(Map<String, dynamic> json) {
    return HomeBannerItem(
      id: json['_id'],
      title: json['title'],
      banner: json['banner'],
      contentType: json['contentType'],
      order: json['order'],
      isActive: json['isActive'],
      isHide: json['isHide'] == true || json['is_hide'] == true || json['hide'] == true,
      content: json['contentId'] is Map<String, dynamic>
          ? HomeBannerContent.fromJson(json['contentId'])
          : null,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'banner': banner,
      'contentType': contentType,
      'order': order,
      'isActive': isActive,
      'isHide': isHide,
      'contentId': content?.toJson(),
      'createdAt': createdAt,
    };
  }
}

class HomeBannerContent {
  final String? id;
  final String? title;
  final String? storyline;
  final String? poster;
  final String? banner;
  final int? releaseYear;
  final List<String>? genre;
  final String? rating;
  final String? duration;
  final String? videoUrl;
  final String? type;
  final String? modelName;
  final bool? isHide;

  bool get isVisible => isHide != true;

  HomeBannerContent({
    this.id,
    this.title,
    this.storyline,
    this.poster,
    this.banner,
    this.releaseYear,
    this.genre,
    this.rating,
    this.duration,
    this.videoUrl,
    this.type,
    this.modelName,
    this.isHide,
  });

  factory HomeBannerContent.fromJson(Map<String, dynamic> json) {
    return HomeBannerContent(
      id: json['_id'],
      title: json['title'],
      storyline: json['storyline'],
      poster: json['poster'],
      banner: json['banner'],
      releaseYear: json['releaseYear'],
      genre: json['genre'] != null ? List<String>.from(json['genre']) : [],
      rating: json['rating']?.toString(),
      duration: json['duration'],
      videoUrl: json['videoUrl'],
      type: json['type'],
      modelName: json['modelName'],
      isHide: json['isHide'] == true || json['is_hide'] == true || json['hide'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'storyline': storyline,
      'poster': poster,
      'banner': banner,
      'releaseYear': releaseYear,
      'genre': genre,
      'rating': rating,
      'duration': duration,
      'videoUrl': videoUrl,
      'type': type,
      'modelName': modelName,
    };
  }
}
