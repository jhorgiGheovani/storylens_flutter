import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:storylens/data/remote/model/general_post_response.dart';
import 'package:storylens/data/remote/model/login_request_body.dart';
import 'package:storylens/data/remote/model/login_response.dart';
import 'package:storylens/data/remote/model/register_request_body.dart';
import 'package:http/http.dart' as http;
import 'package:storylens/data/remote/model/story.dart';
import 'package:storylens/data/remote/model/story_details.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<GeneralPostResponse> registerUser(
      String name, String email, String password) async {
    try {
      String requestBody = jsonEncode(
          RegisterRequestBody(name: name, email: email, password: password)
              .toJson());

      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        body: requestBody,
        headers: {"Content-Type": "application/json"},
      );

      return GeneralPostResponse.fromJson(
          jsonDecode(response.body), response.statusCode);
    } catch (e) {
      throw Exception(
          'Failed to register new user: $e'); //catch error during http
    }
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    String requestBody =
        jsonEncode(LoginRequestBody(email: email, password: password).toJson());

    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      body: requestBody,
      headers: {"Content-Type": "application/json"},
    );

    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<Story> getListStory(String token,
      [int page = 1, int size = 10]) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse("$_baseUrl/stories?&size=$size&page=$page"),
        headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Story.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get stories!');
    }
  }

  Future<StoryDetails> getStoryDetails(String token, String id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response =
        await http.get(Uri.parse("$_baseUrl/stories/$id"), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return StoryDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get details!');
    }
  }

  Future<GeneralPostResponse> uploadStory(
    List<int> bytes,
    String fileName,
    String description,
    String token,
  ) async {
    //header
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    //request body
    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );

    final Map<String, String> fields = {
      "description": description,
    };

    //link url
    final uri = Uri.parse("$_baseUrl/stories");

    //multi part request (Method, url)
    final request = http.MultipartRequest('POST', uri);

    //add request body and headers to request
    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    //get response
    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final GeneralPostResponse uploadResponse =
          GeneralPostResponse.fromJson(jsonDecode(responseData), statusCode);
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
