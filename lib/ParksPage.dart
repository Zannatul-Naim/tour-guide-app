import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParksPage extends StatelessWidget {
  const ParksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('parks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return ParkWidget(park: document);
          }).toList(),
        );
      },
    );
  }
}

class ParkWidget extends StatelessWidget {
  final DocumentSnapshot park;

  const ParkWidget({super.key, required this.park});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset('./images/${park['image']}'),
            ),
          ),
          Text(
            park['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            park['description'],
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.cyan),
          ),
          TextButton(
            child: const Text('See More'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParkDetailPage(park),
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

class ParkDetailPage extends StatelessWidget {
  final DocumentSnapshot park;

  const ParkDetailPage(this.park, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(park['title'])),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset('./images/${park['image']}'),
              ), // Load image from assets
              const SizedBox(height: 20),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Name:         ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          TextSpan(
                              text: park['name'],
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Location:     ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          TextSpan(
                              text: park['location'],
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Type:         ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          TextSpan(
                              text: park['type'],
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Open & Close: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          TextSpan(
                              text: park['time'],
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Details:\n\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                          TextSpan(
                              text: park['fullDescription']
                                  .replaceAll('\\n', '\n'),
                              style: const TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
