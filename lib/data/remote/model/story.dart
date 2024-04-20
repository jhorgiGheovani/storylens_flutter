import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  final bool error;
  final String message;
  final List<ListStory> listStory;

  Story({
    required this.error,
    required this.message,
    required this.listStory,
  });
  factory Story.fromJson(json) => _$StoryFromJson(json);
}

@JsonSerializable()
class ListStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });
  factory ListStory.fromJson(json) => _$ListStoryFromJson(json);
}
