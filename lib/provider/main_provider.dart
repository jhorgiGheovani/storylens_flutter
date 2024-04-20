import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:storylens/data/main_repository.dart';
import 'package:storylens/data/remote/api/general_post_response.dart';
import 'package:storylens/data/remote/model/story.dart';
import 'package:storylens/data/remote/model/story_details.dart';
import 'package:storylens/provider/states.dart';

class MainProvider extends ChangeNotifier {
  final MainRepository mainRepository;

  MainProvider({required this.mainRepository});

  // late Story _story;
  late StoryDetails _storyDetails;
  late GeneralPostResponse _generalPostResponse;
  ResultState _state = ResultState.loading;
  late SubmitState _submitState;

  String _message = '';

  String get message => _message;
  // Story? get story => _story;
  StoryDetails? get storyDetail => _storyDetails;
  GeneralPostResponse? get uploadStoryResponse => _generalPostResponse;
  ResultState get state => _state;
  SubmitState get submitState => _submitState;

  //infinite scrolling
  int? pageItems = 1;
  int sizeItems = 10;
  List<ListStory> stories = []; //array to store list store that fetched

  //upload images
  bool isUploading = true;

  //Image picker
  XFile? imageFile;
  String? imagePath;
  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<void> getStory() async {
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      final data = await mainRepository.getListStory(pageItems!, sizeItems);
      stories.addAll(data.listStory);
      _state = ResultState.hasData;

      if (data.listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }
      notifyListeners();

      //Requirment
      //1. load data with new page when reach end of screen
      //2. load data with previous page when user scroll uo
      //3. only request new api when user successfully add new story, don't request new api when user open detail
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      if (e is ClientException) {
        _message = 'Something wrong with your network!';
      } else {
        _message = e.toString();
      }
    }
  }

  Future<dynamic> getStoryDetails(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final data = await mainRepository.getStoryDetails(id);
      //sukses
      _state = ResultState.hasData;
      notifyListeners();
      return _storyDetails = data;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is ClientException) {
        return _message = 'Something wrong with your network!';
      } else {
        return _message = e.toString();
      }
    }
  }

  Future<dynamic> uploadStory(
    List<int> bytes,
    String fileName,
    String description,
    double? longitude,
    double? latitude,
  ) async {
    try {
      final uploadStory = await mainRepository.uploadStory(
          bytes, fileName, description, longitude, latitude);
      _generalPostResponse = uploadStory;
      isUploading = false;
      _submitState = SubmitState.success;
      notifyListeners();
      return uploadStory;
    } catch (e) {
      _submitState = SubmitState.error;
      isUploading = false;
      notifyListeners();
      if (e is ClientException) {
        return _message = 'Something wrong with your network!';
      } else {
        return _message = e.toString();
      }
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

  Future<List<int>> resizeImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(bytes)!;
    bool isWidthMoreTaller = image.width > image.height;
    int imageTall = isWidthMoreTaller ? image.width : image.height;
    double compressTall = 1;
    int length = imageLength;
    List<int> newByte = bytes;

    do {
      ///
      compressTall -= 0.1;

      final newImage = img.copyResize(
        image,
        width: isWidthMoreTaller ? (imageTall * compressTall).toInt() : null,
        height: !isWidthMoreTaller ? (imageTall * compressTall).toInt() : null,
      );

      length = newImage.length;
      if (length < 1000000) {
        newByte = img.encodeJpg(newImage);
      }
    } while (length > 1000000);

    return newByte;
  }
}
