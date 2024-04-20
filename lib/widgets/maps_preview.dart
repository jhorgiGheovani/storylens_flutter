// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storylens/data/remote/model/story_details.dart';

class MapsPreview extends StatefulWidget {
  const MapsPreview({
    super.key,
    this.latitude,
    this.longitude,
  });
  final double? latitude;
  final double? longitude;

  @override
  State<StatefulWidget> createState() => _MapsPreview();
}

class _MapsPreview extends State<MapsPreview> {
  late LatLng initial;
  late StoryDetailsItem story;

  @override
  void initState() {
    super.initState();
    initial = LatLng(widget.longitude ?? 0, widget.latitude ?? 0);
  }

  late GoogleMapController mapController;
  geo.Placemark? placemark;
  late final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        zoom: 13,
        target: initial,
      ),
      markers: markers,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) async {
        final info = await geo.placemarkFromCoordinates(
            initial.latitude, initial.longitude);
        final place = info[0];
        final street = place.street!;
        final address =
            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        setState(() {
          placemark = place;
        });
        defineMarker(initial, street, address);

        setState(() {
          mapController = controller;
        });
      },
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
