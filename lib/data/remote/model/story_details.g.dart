// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDetails _$StoryDetailsFromJson(Map<String, dynamic> json) => StoryDetails(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: StoryDetailsItem.fromJson(json['story']),
    );

Map<String, dynamic> _$StoryDetailsToJson(StoryDetails instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };

StoryDetailsItem _$StoryDetailsItemFromJson(Map<String, dynamic> json) =>
    StoryDetailsItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: json['createdAt'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StoryDetailsItemToJson(StoryDetailsItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt,
      'lat': instance.lat,
      'lon': instance.lon,
    };
