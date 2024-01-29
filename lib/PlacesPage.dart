// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_test/MapScreen.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('places').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return PlaceWidget(place: document);
          }).toList(),
        );
      },
    );
  }
}

class PlaceWidget extends StatelessWidget {
  final DocumentSnapshot place;

  const PlaceWidget({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset('./images/${place['image']}'),
            ),
          ),
          Text(
            place['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          Text(
            place['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.cyan),
          ),
          TextButton(
            child: const Text(
              'See More',
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailPage(place),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class PlaceDetailPage extends StatelessWidget {
  final DocumentSnapshot place;

  const PlaceDetailPage(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    GeoPoint geoPoint = place['location']; // your GeoPoint from Firebase
    LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude); // convert to LatLng
    return Scaffold(
      appBar: AppBar(title: Text(place['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                './images/${place['image']}',
              ), // Load image from assets
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Text(
                  place['fullDescription'].replaceAll('\\n', '\n'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Location",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500, // Set as needed
                child: MapScreen(location: latLng),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
