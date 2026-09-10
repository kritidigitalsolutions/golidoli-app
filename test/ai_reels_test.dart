import 'package:flutter_test/flutter_test.dart';
import 'package:golidoli_app/constants/app_url.dart';
import 'package:golidoli_app/features/home/models/ai_reel_model.dart';
import 'package:golidoli_app/features/web_series/model/SeriesModel.dart';

void main() {
  group('AI Reels Model and URL Generation Tests', () {
    test('AppUrl.aiReelsFeed builds correct URL with limit and sessionId', () {
      final initialUrl = AppUrl.aiReelsFeed(limit: 10);
      expect(initialUrl, '${AppUrl.baseUrl}/api/ai-reels?limit=10');

      const sessionId = '6a8e96a6ce2a3236c3ea8e22';
      final nextBatchUrl = AppUrl.aiReelsFeed(limit: 10, sessionId: sessionId);
      expect(
        nextBatchUrl,
        '${AppUrl.baseUrl}/api/ai-reels?limit=10&sessionId=$sessionId',
      );

      final viewUrl = AppUrl.aiReelView('reel123');
      expect(viewUrl, '${AppUrl.baseUrl}/api/ai-reels/reel123/view');

      final completeUrl = AppUrl.aiReelComplete('reel123');
      expect(completeUrl, '${AppUrl.baseUrl}/api/ai-reels/reel123/complete');
    });

    test('AiReelsResponse parses user payload correctly', () {
      final json = {
        "success": true,
        "message": "Trending AI Reels fetched successfully",
        "data": [
          {
            "_id": "6a8e8cda61e380a75167993d",
            "title": "Rhythm of the City",
            "description": "Fast-paced montage of subway crowds and traffic lights.",
            "thumbnail": "/uploads/aireels/posters/dummy4.jpg",
            "videoUrl": "/uploads/aireels/videos/dummy4.mp4",
            "duration": "0:18",
            "views": 53000,
            "like": 14200,
            "isPublished": true,
            "priority": 15,
            "publishedAt": "2026-08-26T06:51:06.435Z",
            "__v": 0,
            "createdAt": "2026-08-26T06:51:06.439Z",
            "updatedAt": "2026-08-26T06:51:06.439Z"
          },
          {
            "_id": "6a8e8cda61e380a75167993c",
            "title": "Whispers of the Forest",
            "description": "Light rays piercing through ancient redwoods.",
            "thumbnail": "/uploads/aireels/posters/dummy3.jpg",
            "videoUrl": "/uploads/aireels/videos/dummy3.mp4",
            "duration": "0:12",
            "views": 8200,
            "like": 2100,
            "isPublished": true,
            "priority": 2,
            "publishedAt": "2026-08-26T06:51:06.434Z",
            "__v": 0,
            "createdAt": "2026-08-26T06:51:06.439Z",
            "updatedAt": "2026-08-26T06:51:06.439Z"
          }
        ],
        "pagination": {
          "limit": 10,
          "sessionId": "6a8e96a6ce2a3236c3ea8e22",
          "hasMore": false
        },
        "meta": {
          "feedType": "trending",
          "mode": "fresh",
          "allWatched": false,
          "hasUnwatched": true,
          "replayAvailable": false,
          "replayEnabled": false,
          "totalPublished": 4,
          "watchedPublished": 0
        }
      };

      final response = AiReelsResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, 'Trending AI Reels fetched successfully');
      expect(response.data.length, 2);
      expect(response.data.first.id, '6a8e8cda61e380a75167993d');
      expect(response.data.first.title, 'Rhythm of the City');
      expect(response.data.first.likes, 14200);
      expect(response.data.first.views, 53000);
      expect(
        response.data.first.fullVideoUrl,
        '${AppUrl.baseUrl}/uploads/aireels/videos/dummy4.mp4',
      );
      expect(
        response.data.first.fullThumbnailUrl,
        '${AppUrl.baseUrl}/uploads/aireels/posters/dummy4.jpg',
      );
      expect(response.pagination.sessionId, '6a8e96a6ce2a3236c3ea8e22');
      expect(response.pagination.hasMore, false);
      expect(response.meta.allWatched, false);
      expect(response.meta.hasUnwatched, true);
    });

    test('AiReelModel parses isLiked boolean and numeric representations', () {
      final json1 = {
        "_id": "reel1",
        "title": "Reel 1",
        "isLiked": true,
        "likes": 10,
      };
      expect(AiReelModel.fromJson(json1).isLiked, true);

      final json2 = {
        "_id": "reel2",
        "title": "Reel 2",
        "is_liked": 1,
        "likes": 5,
      };
      expect(AiReelModel.fromJson(json2).isLiked, true);

      final json3 = {
        "_id": "reel3",
        "title": "Reel 3",
        "liked": false,
        "likes": 0,
      };
      expect(AiReelModel.fromJson(json3).isLiked, false);
    });

    test('AppUrl and Models for AI Reel Like and Share', () {
      const reelId = '60f7a1234567890';

      // URLs
      expect(
        AppUrl.toggleLikeAiReel(reelId),
        '${AppUrl.baseUrl}/api/interaction/toggle/like/aiReel/$reelId',
      );
      expect(
        AppUrl.aiReelShare(reelId),
        '${AppUrl.baseUrl}/api/ai-reels/$reelId/share',
      );

      // Share Response
      final shareJson = {
        "success": true,
        "message": "AI Reel share recorded successfully",
        "data": {
          "aiReelId": reelId,
          "shares": 1
        }
      };
      final shareResponse = AiReelShareResponse.fromJson(shareJson);
      expect(shareResponse.success, true);
      expect(shareResponse.message, "AI Reel share recorded successfully");
      expect(shareResponse.aiReelId, reelId);
      expect(shareResponse.shares, 1);
    });

    test('Series.fromJson parses user Breaking Bad payload and isPremium correctly', () {
      final json = {
        "_id": "6a86d965977f982e2c1e327f",
        "title": "Breaking Bad",
        "description": "A chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing...",
        "genre": ["Crime", "Drama", "Thriller"],
        "releaseYear": 2008,
        "duration": "3 Episodes",
        "language": "English",
        "poster": "https://images.unsplash.com/photo-1588681664899-f142ff2dc9b1?q=80&w=800&auto=format&fit=crop",
        "banner": "https://images.unsplash.com/photo-1533488765986-dfa2a9939acd?q=80&w=1600&auto=format&fit=crop",
        "isComingSoon": false,
        "trailerUrl": "https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4",
        "isPremium": true,
        "priority": 2,
        "rating": 9.5,
        "category": ["trending", "top10", "recommended"],
        "likes": 1,
        "dislikes": 0,
        "totalSeasons": 1,
        "totalEpisodes": 3,
        "isPublished": true,
        "createdAt": "2026-08-20T10:39:33.789Z",
        "updatedAt": "2026-08-26T06:05:07.073Z",
        "slug": "breaking-bad-1787222373789",
        "__v": 0,
        "isPopular": false,
      };

      final series = Series.fromJson(json);
      expect(series.id, "6a86d965977f982e2c1e327f");
      expect(series.title, "Breaking Bad");
      expect(series.isPremium, true);
      expect(series.isComingSoon, false);
      expect(series.likes, 1);
      expect(series.dislikes, 0);
    });
  });
}
