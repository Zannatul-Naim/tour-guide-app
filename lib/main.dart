import 'package:flutter/material.dart';
import 'package:tour_guide_test/firebase_options.dart';
import './PlacesPage.dart';
import './ParksPage.dart';
import './FoodsPage.dart';
import './RestaurantsPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tour_guide_test/More.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Explore Kushtia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/tour': (context) => const TourPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tour Guide Kushtia',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(224, 235, 242, 240)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset(
                  "./images/kushtia_home.jpg",
                  // height: 500.0,
                  // width: 480.0,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Welcome To Kushtia',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'The City of Culture',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tour');
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
              ),
              child: const SizedBox(
                height: 25,
                width: 190,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Let's take a tour",
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
            const SizedBox(
              height: 25,
            ),
            const Text(
              "History of Kushtia",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
              child: const Text(
                "Kushtia District is in the Khulna division of western Bangladesh. It’s the second largest municipality and the eleventh largest city in Bangladesh. The district has been separate since India’s partition. Kushtia is the birthplace of several historical figures, including Mir Mosharraf Hossain, Bagha Jatin, and Lalon. Rabindranath Tagore, a Nobel laureate poet, spent his early life in Shelaidaha, a village in the district.\n\nThe district played a significant role in the Bangladesh Liberation War. After Bangladesh’s independence, Kushtia saw many development projects. The Islamic University was founded in Kushtia in 1979, moved in 1982, and returned in 1990. In 1984, Chuadanga and Meherpur, two subdivisions of Kushtia, were named separate districts.\n\nThe district spans an area of approximately 1,621.15 square kilometers and has a population of approximately 2,149,692 people. It consists of six upazilas, one police thana, five municipalities, 39 wards, 70 mahallas, 61 union parishads, 710 mouzas, and 978 villages.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  _TourPageState createState() => _TourPageState();
}

class _TourPageState extends State<TourPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tour Guide Kushtia',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(224, 235, 242, 240)),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.location_city),
              text: 'Places',
            ),
            Tab(
              icon: Icon(Icons.nature),
              text: 'Parks',
            ),
            Tab(
              icon: Icon(Icons.fastfood),
              text: 'Food',
            ),
            Tab(icon: Icon(Icons.restaurant), text: "Resturant"),
            Tab(
              icon: Icon(Icons.more_horiz),
              text: 'More',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PlacesPage(),
          ParksPage(),
          FoodsPage(),
          RestaurantsPage(),
          More()
        ],
      ),
    );
  }
}
