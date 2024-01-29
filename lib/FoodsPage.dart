
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('foods').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return FoodWidget(food: document);
          }).toList(),
        );
      },
    );
  }
}

class FoodWidget extends StatelessWidget {
  final DocumentSnapshot food;

  const FoodWidget({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset('./images/${food['image']}'),
            ),
          ),
          Text(
            food['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          Text(
            food['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.cyan),
          ),
          TextButton(
            child: const Text('See More'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailPage(food),
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

class FoodDetailPage extends StatelessWidget {
  final DocumentSnapshot food;

  const FoodDetailPage(this.food, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food['name'])),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset('./images/${food['image']}'),
              ),
              const SizedBox(height: 20),
              // Text(
              //   'Name: ${food['name']}',
              //   style:
              //       const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Name: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '${food['name']}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              // Text(
              //   'Description: ${food['fullDescription']}'
              //       .replaceAll('\\n', '\n'),
              //   style: const TextStyle(color: Colors.black),
              // ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: "Description: \n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    TextSpan(
                      text: food['fullDescription'].replaceAll('\\n', '\n').replaceAll('\\t', '\t'),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Price: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '৳${food['price']}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              // Text(
              //   'Ingredients: ${food['ingredients']}'.replaceAll('\\n', '\n'),
              //   style: const TextStyle(color: Colors.black),
              // ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Ingredients: \n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: '${food['ingredients']}'.replaceAll('\\n', '\n'),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 24, 162, 172),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
