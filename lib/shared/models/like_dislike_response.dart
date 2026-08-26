class LikeDislikeResponse {
  final bool success;
  final String message;
  final int totalLikes;
  final int totalDislikes;
  final String contentType;

  const LikeDislikeResponse({
    required this.success,
    required this.message,
    required this.totalLikes,
    required this.totalDislikes,
    this.contentType = '',
  });

  factory LikeDislikeResponse.fromJson(Map<String, dynamic> json) {
    return LikeDislikeResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      totalLikes: (json['totalLikes'] is num)
          ? (json['totalLikes'] as num).toInt()
          : (int.tryParse(json['totalLikes']?.toString() ?? '0') ?? 0),
      totalDislikes: (json['totalDislikes'] is num)
          ? (json['totalDislikes'] as num).toInt()
          : (int.tryParse(json['totalDislikes']?.toString() ?? '0') ?? 0),
      contentType: json['contentType']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'totalLikes': totalLikes,
    'totalDislikes': totalDislikes,
    'contentType': contentType,
  };
}
