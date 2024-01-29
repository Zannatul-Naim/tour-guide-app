import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './FoodPage.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: ListTile(
                  title: Text(document['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantDetailPage(restaurant: document),
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class RestaurantDetailPage extends StatelessWidget {
  final DocumentSnapshot restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant['name'])),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./images/${restaurant['image']}'),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            buildFoodTypeButton(context, 'Bengali'),
            buildFoodTypeButton(context, 'Chinese'),
            buildFoodTypeButton(context, 'Korean'),
            buildFoodTypeButton(context, 'Italian'),
            // Add more buttons for other food types...
          ],
        ),
      ),
    );
  }

  Widget buildFoodTypeButton(BuildContext context, String foodType) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 68, 138, 255)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        child: Text(foodType),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodPage(restaurant: restaurant, foodType: foodType),
            ),
          );
        },
      ),
    );
  }
}