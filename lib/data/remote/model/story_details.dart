import 'package:json_annotation/json_annotation.dart';

part 'story_details.g.dart';

@JsonSerializable()
class StoryDetails {
  final bool error;
  final String message;
  final StoryDetailsItem story;
  StoryDetails({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetails.fromJson(json) => _$StoryDetailsFromJson(json);
}

@JsonSerializable()
class StoryDetailsItem {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  StoryDetailsItem({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory StoryDetailsItem.fromJson(json) => _$StoryDetailsItemFromJson(json);
}
