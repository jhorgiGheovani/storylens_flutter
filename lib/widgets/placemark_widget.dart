import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
import 'package:storylens/provider/page_manager.dart';

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({
    super.key,
    required this.placemark,
    this.lat,
    this.lan,
    required this.backToAddStoryPage,
  });
  final geo.Placemark placemark;
  final double? lat;
  final double? lan;
  final Function() backToAddStoryPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                TextButton(
                    onPressed: () {
                      if (lan != null && lat != null) {
                        context.read<PageManager<double>>().setLon(lan!);
                        context.read<PageManager<double>>().setLat(lat!);
                      }

                      backToAddStoryPage();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green.shade500,
                      minimumSize: const Size(80, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
