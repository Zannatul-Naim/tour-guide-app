// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodPage extends StatelessWidget {
  final DocumentSnapshot restaurant;
  final String foodType;

  const FoodPage({super.key, required this.restaurant, required this.foodType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$foodType Foods'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurant.id)
            .collection('foods')
            .where('type', isEqualTo: foodType)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No $foodType foods found in this Restaurant.\nSorry!', textAlign: TextAlign.center,));
          }

          return ListView.separated(
            separatorBuilder: (context, index) =>
                const Divider(height: 20), // This adds space between items
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.all(8.0), // This adds margin
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0), // This adds padding
                  leading: ClipOval(
                    child: Image.network(document['image']),
                  ),
                  title: Text(document['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
