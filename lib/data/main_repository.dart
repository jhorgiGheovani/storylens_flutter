import 'package:shared_preferences/shared_preferences.dart';
import 'package:storylens/data/remote/api/api_service.dart';
import 'package:storylens/data/remote/api/general_post_response.dart';
import 'package:storylens/data/remote/model/story.dart';
import 'package:storylens/data/remote/model/story_details.dart';

class MainRepository {
  final String tokenKey = 'TOKEN';

  Future<Story> getListStory(int page, int size) async {
    try {
      final apiService = ApiService();
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(tokenKey);

      return await apiService.getListStory(token!, page, size);
    } catch (e) {
      rethrow;
    }
  }

  Future<StoryDetails> getStoryDetails(String id) async {
    try {
      final apiService = ApiService();
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(tokenKey);
      return await apiService.getStoryDetails(token!, id);
    } catch (e) {
      rethrow;
    }
  }

  Future<GeneralPostResponse> uploadStory(
    List<int> bytes,
    String fileName,
    String description,
    double? longitude,
    double? latitude,
  ) async {
    try {
      final apiService = ApiService();
      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString(tokenKey);

      return await apiService.uploadStory(
          bytes, fileName, description, token!, longitude, latitude);
    } catch (e) {
      rethrow;
    }
  }
}
