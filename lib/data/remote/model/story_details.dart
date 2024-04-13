class StoryDetails {
  final bool error;
  final String message;
  final StoryDetailsItem story;

  StoryDetails({
    required this.error,
    required this.message,
    required this.story,
  });

  factory StoryDetails.fromJson(Map<String, dynamic> json) => StoryDetails(
        error: json["error"],
        message: json["message"],
        story: StoryDetailsItem.fromJson(json["story"]),
      );
}

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

  factory StoryDetailsItem.fromJson(Map<String, dynamic> json) =>
      StoryDetailsItem(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: json["createdAt"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );
}
