// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:storylens/data/main_repository.dart';
import 'package:storylens/data/remote/model/story_details.dart';
import 'package:storylens/provider/main_provider.dart';
import 'package:storylens/provider/states.dart';

class DetailPage extends StatefulWidget {
  final String quoteId;
  const DetailPage({
    super.key,
    required this.quoteId,
  });

  @override
  State<StatefulWidget> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Details",
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey.shade300, // You can specify any color here
            height: 0.2,
          ),
        ),
      ),
      body: _buildDetails(),
    );
  }

  Widget _buildDetails() {
    return ChangeNotifierProvider<MainProvider>(
        create: (_) => MainProvider(mainRepository: MainRepository())
          ..getStoryDetails(widget.quoteId),
        child: Consumer<MainProvider>(builder: (context, provider, _) {
          if (provider.state == ResultState.loading) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ));
          } else if (provider.state == ResultState.hasData) {
            return _buildContents(provider.storyDetail!.story);
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Material(
                child: Text(provider.message),
              ),
            );
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        }));
  }

  Widget _buildContents(StoryDetailsItem data) {
    return SafeArea(
      child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidCircleUser,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        data.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    data.description,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                  ),
                  Center(
                      child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                      child: Image.network(
                        data.photoUrl, // Replace this URL with your image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                  Text(
                    convertDate(data.createdAt),
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                ],
              ))),
    );
  }
}

String convertDate(String input) {
  // Convert the original timestamp to a DateTime object
  DateTime dateTime = DateTime.parse(input);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('HH:mm · dd MMM yy').format(dateTime);
  return formattedDate;
}
