import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storylens/provider/main_provider.dart';
import 'package:storylens/provider/page_manager.dart';
import 'package:storylens/provider/states.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage(
      {super.key, required this.uploadSuccess, required this.gotoMapsScreen});

  final Function() uploadSuccess;
  final Function() gotoMapsScreen;

  @override
  State<StatefulWidget> createState() => _AddStoryPage();
}

class _AddStoryPage extends State<AddStoryPage> {
  final descController = TextEditingController();
  // double? lon = null;
  // double? lat = null;
  double? lon;
  double? lat;

  @override
  void dispose() {
    super.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.uploadSuccess();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          final mainProvider = context.read<MainProvider>();
                          final imagePath = mainProvider.imagePath;
                          final imageFile = mainProvider.imageFile;
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          if (imagePath == null || imageFile == null) {
                            scaffoldMessenger.showSnackBar(const SnackBar(
                              content: Text("Please select an images first!"),
                            ));
                          }
                          _onUpload(
                              descController.text, scaffoldMessenger, lon, lat);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(80, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Post",
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    hintText: "What's happening?",
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  child: context.watch<MainProvider>().imagePath == null
                      ? null
                      : _showImage(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Divider(
                  color: Colors.grey.shade300,
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onGalleryView();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            FontAwesomeIcons.image,
                            color: Colors.blue.shade500,
                            size: 18,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _onCameraView();
                        },
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.blue.shade500,
                          size: 19,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          widget.gotoMapsScreen();
                          final provider = context.read<PageManager<double>>();
                          final results = await Future.wait([
                            provider.getLon(),
                            provider.getLat(),
                          ]);
                          lon = results[0];
                          lat = results[1];
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.blue.shade500,
                              size: 18,
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onUpload(
    String desc,
    ScaffoldMessengerState scaffoldMessenger,
    double? longitude,
    double? latitude,
  ) async {
    final mainProvider = context.read<MainProvider>();

    final imagePath = mainProvider.imagePath;
    final imageFile = mainProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await mainProvider.compressImage(bytes);

    await mainProvider.uploadStory(
        newBytes, fileName, desc, longitude, latitude);

    if (mainProvider.submitState == SubmitState.success) {
      mainProvider.setImageFile(null);
      mainProvider.setImagePath(null);
      //  final mainProvider = context.read<MainProvider>();
      // mainProvider.getStory();
      mainProvider.stories.clear();
      mainProvider.pageItems = 1;
      Future.microtask(() async => mainProvider.getStory());
      widget.uploadSuccess();
      // await mainProvider.getStory();
    } else if (mainProvider.submitState == SubmitState.error) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(mainProvider.uploadStoryResponse!.message),
      ));
    }
  }

  _onGalleryView() async {
    final provider = context.read<MainProvider>();
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<MainProvider>();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    /// todo-image-02: pick image from camera app
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    /// todo-image-03: check the result and update the image
    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<MainProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
