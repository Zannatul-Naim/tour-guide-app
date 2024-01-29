// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot category) {
            // Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: ListTile(
                  title: Text(category['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CategoryScreen(category: category),
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

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot category;

  CategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc(category.id)
          .collection('items')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print((snapshot.error) as String);
          return Text((snapshot..error) as String);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              category['name'],
            ),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot item) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      // backgroundImage: AssetImage('images/${item['imageName']}'),
                      backgroundImage: NetworkImage(
                        (item['imageName']),
                      ),
                    ),
                    title: Text(item['name']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemPage(
                            item: item,
                            category: category,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class ItemPage extends StatelessWidget {
  final DocumentSnapshot category;
  final DocumentSnapshot item;

  const ItemPage({super.key, required this.category, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5.0),
                ),
                child: Image.network(
                  item['imageName'],
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                item['description'].replaceAll('\\n', '\n'),
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {
                  // ignore: deprecated_member_use
                  launch(item['wikipediaUrl']);
                },
                child: const SizedBox(
                  height: 35,
                  width: 190,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Go to Wikipedia",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
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
