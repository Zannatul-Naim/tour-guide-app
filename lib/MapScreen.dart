// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final LatLng location;

  const MapScreen({required this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LatLng currentLocation = LatLng(24.368341517612453, 88.63759285634703);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    Geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print(e);
      print('Using default location');
    });
  }

void _launchMaps(double lat, double lon) async {
  String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=$lat,$lon&travelmode=driving';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not launch \$googleUrl';
  }
}



  void _zoomIn() {
    mapController.move(mapController.center, mapController.zoom + 1);
  }

  void _zoomOut() {
    mapController.move(mapController.center, mapController.zoom - 1);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: widget.location, // this is your expected location
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: widget.location, // marker for expected location
                  builder: (ctx) => const Icon(Icons.location_on, color: Colors.red),
                ),
                // only add the marker if currentLocation is not null
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: currentLocation, // marker for current location
                  builder: (ctx) => const Icon(Icons.my_location, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.zoom_in),
                onPressed: _zoomIn,
              ),
              IconButton(
                icon: Icon(Icons.zoom_out),
                onPressed: _zoomOut,
              ),
            ],
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        _launchMaps(widget.location.latitude, widget.location.longitude);
      },
      child: Icon(Icons.directions),
    ),
    );
  }
}
