// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:storylens/data/remote/model/story.dart';

class ListStoryItem extends StatelessWidget {
  final ListStory? story;
  final Function(String) onTapped;
  const ListStoryItem({
    super.key,
    this.story,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => onTapped(story!.id),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                FontAwesomeIcons.solidCircleUser,
                size: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story!.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        story!.description,
                        textAlign: TextAlign.justify,
                        softWrap: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            minWidth: 5000, maxHeight: 350),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the radius as needed
                          child: Image.network(
                            story!
                                .photoUrl, // Replace this URL with your image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
