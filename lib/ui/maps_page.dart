// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:storylens/widgets/placemark_widget.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key, required this.backToAddStoryPage});
  final Function() backToAddStoryPage;
  @override
  State<StatefulWidget> createState() => _MapsScreen();
}

class _MapsScreen extends State<MapsScreen> {
  final initial = const LatLng(-6.8957473, 107.6337669);
  double? latitude = -6.8957473;
  double? longitude = 107.6337669;
  late GoogleMapController mapController;
  geo.Placemark? placemark;
  late final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              zoom: 13,
              target: initial,
            ),
            markers: markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onLongPress: (LatLng latLng) {
              onLongPressGoogleMap(latLng);
              latitude = latLng.latitude;
              longitude = latLng.longitude;
            },
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
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                onMyLocationButtonPress();
              },
            ),
          ),
          if (placemark == null)
            const SizedBox()
          else
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: PlacemarkWidget(
                  placemark: placemark!,
                  lan: latitude,
                  lat: longitude,
                  backToAddStoryPage: widget.backToAddStoryPage),
            ),
        ],
      )),
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

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }
    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    setState(() {
      latitude = latLng.latitude;
      longitude = latLng.longitude;
    });
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street!, address);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 18,
        ),
      ),
      // CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
