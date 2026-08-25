import 'package:flutter_test/flutter_test.dart';
import 'package:golidoli_app/features/audio_play/models/audio_category_model.dart';
import 'package:golidoli_app/features/audio_play/models/audio_story_model.dart';
import 'package:golidoli_app/features/audio_play/models/audio_stories_response_model.dart';

void main() {
  test('AudioStoriesResponseModel and AudioStoryModel match API response', () {
    final jsonResponse = {
      "success": true,
      "stories": [
        {
          "_id": "6a8c238dbd184ab8ebc8b561",
          "title": "Love in Paris",
          "description":
              "A chance encounter in the city of love changes two lives forever.",
          "author": "",
          "narrator": "",
          "coverImage":
              "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500&q=80",
          "bannerImage":
              "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=1000&q=80",
          "categories": [
            {
              "_id": "6a8c238cbd184ab8ebc8b55e",
              "name": "Romance",
              "slug": "romance-1787569036934"
            }
          ],
          "totalEpisodes": 0,
          "isPremium": true,
          "isPublished": true,
          "status": "Published",
          "priority": 2,
          "likes": [],
          "rating": 0,
          "createdAt": "2026-08-24T10:57:17.147Z",
          "updatedAt": "2026-08-24T10:57:17.147Z",
          "slug": "love-in-paris-1787569037147",
          "__v": 0,
          "isLocked": true
        },
        {
          "_id": "6a8c238dbd184ab8ebc8b560",
          "title": "The Haunted Mansion",
          "description":
              "A group of friends explore an abandoned mansion, only to find they are not alone.",
          "author": "",
          "narrator": "",
          "coverImage":
              "https://images.unsplash.com/photo-1519097835154-2baeb8c8eb25?w=500&q=80",
          "bannerImage":
              "https://images.unsplash.com/photo-1519097835154-2baeb8c8eb25?w=1000&q=80",
          "categories": [
            {
              "_id": "6a8c238cbd184ab8ebc8b55d",
              "name": "Horror",
              "slug": "horror-1787569036865"
            }
          ],
          "totalEpisodes": 0,
          "isPremium": false,
          "isPublished": true,
          "status": "Published",
          "priority": 1,
          "likes": [],
          "rating": 0,
          "createdAt": "2026-08-24T10:57:17.080Z",
          "updatedAt": "2026-08-24T10:57:17.080Z",
          "slug": "the-haunted-mansion-1787569037080",
          "__v": 0,
          "isLocked": false
        }
      ]
    };

    final response = AudioStoriesResponseModel.fromJson(jsonResponse);
    expect(response.success, true);
    expect(response.stories.length, 2);

    final story1 = response.stories[0];
    expect(story1.id, "6a8c238dbd184ab8ebc8b561");
    expect(story1.title, "Love in Paris");
    expect(
        story1.description,
        "A chance encounter in the city of love changes two lives forever.");
    expect(story1.coverImage,
        "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=500&q=80");
    expect(story1.bannerImage,
        "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=1000&q=80");
    expect(story1.categories.length, 1);
    expect(story1.categories[0].id, "6a8c238cbd184ab8ebc8b55e");
    expect(story1.categories[0].name, "Romance");
    expect(story1.categories[0].slug, "romance-1787569036934");
    expect(story1.genre, "Romance");
    expect(story1.categoryId, "6a8c238cbd184ab8ebc8b55e");
    expect(story1.totalEpisodes, 0);
    expect(story1.isPremium, true);
    expect(story1.isPublished, true);
    expect(story1.status, "Published");
    expect(story1.priority, 2);
    expect(story1.rating, 0.0);
    expect(story1.slug, "love-in-paris-1787569037147");
    expect(story1.v, 0);
    expect(story1.isLocked, true);

    final story2 = response.stories[1];
    expect(story2.id, "6a8c238dbd184ab8ebc8b560");
    expect(story2.title, "The Haunted Mansion");
    expect(story2.categories[0].name, "Horror");
    expect(story2.isPremium, false);
    expect(story2.isLocked, false);
    expect(story2.priority, 1);
  });

  test('Audio story category filtering by ID, name, and slug', () {
    final story1 = AudioStoryModel(
      id: "1",
      title: "Love in Paris",
      categories: [
        const AudioCategoryModel(
          id: "cat_romance",
          name: "Romance",
          slug: "romance-123",
        ),
      ],
    );

    final story2 = AudioStoryModel(
      id: "2",
      title: "The Haunted Mansion",
      categories: [
        const AudioCategoryModel(
          id: "cat_horror",
          name: "Horror",
          slug: "horror-456",
        ),
      ],
    );

    final all = [story1, story2];

    // Filter by Romance
    final romanceCat = const AudioCategoryModel(id: "cat_romance", name: "Romance");
    final romanceStories = all.where((s) => s.categories.any((c) => c.id == romanceCat.id || c.name.toLowerCase() == romanceCat.name.toLowerCase())).toList();
    expect(romanceStories.length, 1);
    expect(romanceStories.first.title, "Love in Paris");

    // Filter by Horror
    final horrorCat = const AudioCategoryModel(id: "cat_horror", name: "Horror");
    final horrorStories = all.where((s) => s.categories.any((c) => c.id == horrorCat.id || c.name.toLowerCase() == horrorCat.name.toLowerCase())).toList();
    expect(horrorStories.length, 1);
    expect(horrorStories.first.title, "The Haunted Mansion");
  });
}

