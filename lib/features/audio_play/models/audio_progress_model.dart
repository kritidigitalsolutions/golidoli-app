import 'package:golidoli_app/features/audio_play/models/audio_episode_model.dart';

class AudioProgressModel {
  final String id;
  final String episodeId;
  final int progressSeconds;
  final int durationSeconds;
  final bool isCompleted;
  final AudioEpisodeModel? episode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AudioProgressModel({
    required this.id,
    required this.episodeId,
    required this.progressSeconds,
    required this.durationSeconds,
    required this.isCompleted,
    this.episode,
    this.createdAt,
    this.updatedAt,
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
      progressSeconds: rawProg is int
          ? rawProg
          : (int.tryParse(rawProg.toString()) ?? 0),
      durationSeconds: rawDur is int
          ? rawDur
          : (int.tryParse(rawDur.toString()) ?? 0),
      isCompleted: json['isCompleted'] == true,
      episode: parsedEpisode,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'episodeId': episodeId,
    'progressSeconds': progressSeconds,
    'durationSeconds': durationSeconds,
    'isCompleted': isCompleted,
    if (episode != null) 'episode': episode!.toJson(),
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };

  AudioProgressModel copyWith({
    String? id,
    String? episodeId,
    int? progressSeconds,
    int? durationSeconds,
    bool? isCompleted,
    AudioEpisodeModel? episode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AudioProgressModel(
      id: id ?? this.id,
      episodeId: episodeId ?? this.episodeId,
      progressSeconds: progressSeconds ?? this.progressSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      episode: episode ?? this.episode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
