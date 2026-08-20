class WatchlistResponse {
  final bool? success;
  final int? count;
  final String? message;
  final List<WatchlistItem>? data;

  WatchlistResponse({this.success, this.count, this.message, this.data});

  factory WatchlistResponse.fromJson(Map<String, dynamic> json) {
    return WatchlistResponse(
      success: json['success'],
      count: json['count'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => WatchlistItem.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class WatchlistItem {
  final String? id;
  final String? user;
  final WatchlistMediaItem? item;
  final String? itemModel;
  final String? createdAt;
  final String? updatedAt;

  WatchlistItem({
    this.id,
    this.user,
    this.item,
    this.itemModel,
    this.createdAt,
    this.updatedAt,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['_id'],
      user: json['user'],
      item: json['item'] is Map<String, dynamic>
          ? WatchlistMediaItem.fromJson(json['item'])
          : null,
      itemModel: json['itemModel'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'item': item?.toJson(),
      'itemModel': itemModel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class WatchlistMediaItem {
  final String? id;
  final String? title;
  final String? poster;
  final String? banner;
  final int? releaseYear;
  final List<String>? genre;
  final String? rating;
  final String? duration;

  WatchlistMediaItem({
    this.id,
    this.title,
    this.poster,
    this.banner,
    this.releaseYear,
    this.genre,
    this.rating,
    this.duration,
  });

  factory WatchlistMediaItem.fromJson(Map<String, dynamic> json) {
    return WatchlistMediaItem(
      id: json['_id'],
      title: json['title'],
      poster: json['poster'],
      banner: json['banner'],
      releaseYear: json['releaseYear'],
      genre: json['genre'] != null ? List<String>.from(json['genre']) : [],
      rating: json['rating']?.toString(),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'poster': poster,
      'banner': banner,
      'releaseYear': releaseYear,
      'genre': genre,
      'rating': rating,
      'duration': duration,
    };
  }
}
