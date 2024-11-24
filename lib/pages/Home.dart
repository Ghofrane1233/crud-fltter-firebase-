import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:version2/auth/login.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:version2/pages/CarDetails.dart';
import 'package:version2/pages/category.dart';
import 'package:version2/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class CarCategory {
  final String name;
  final String imagePath;

  CarCategory({required this.name, required this.imagePath});
}

List<CarCategory> carCategories = [
  CarCategory(name: "Lamborghini", imagePath: "assets/c2.png"),
  CarCategory(name: "Lexus", imagePath: "assets/c3.png"),
  CarCategory(name: "Toyota", imagePath: "assets/c4.png"),
  CarCategory(name: "Ferrari", imagePath: "assets/c5.png"),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String _searchText = ""; // Texte de recherche

  final List<Widget> _pages = [
    const HomeContent(),
    const Center(child: Text('Search', style: TextStyle(fontSize: 24))),
    const Profile(userId: '',),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Home',
        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
        centerTitle: true,
        backgroundColor: const Color(0xFF2972FF),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.userCircle,
              size: 40.0,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? HomeContent(searchText: _searchText) 
          : _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        color: const Color(0xFF2972FF),
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.grey[200]!,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String searchText;

  const HomeContent({super.key, this.searchText = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search your dream',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
            color: Color(0xFF2972FF)),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Super car to ride',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    // Mettre à jour le texte de recherche
                    (context.findAncestorStateOfType<_HomeState>() as _HomeState)
                        .setState(() {
                      (context.findAncestorStateOfType<_HomeState>() as _HomeState)
                          ._searchText = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF2972FF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF2972FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xFF2972FF)),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2972FF),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.slidersH),
                  color: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Filter options coming soon!')),
                    );
                  },
                ),
              ),
            ],
          ),
         SizedBox(
  height: 120,
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('categories').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No categories found.'));
      }

      final categories = snapshot.data!.docs.map((doc) {
        final categoryData = doc.data() as Map<String, dynamic>;
        return CarCategory(
          name: categoryData['name'] ?? 'Unknown',
          imagePath: categoryData['image'] ?? '',
        );
      }).toList();

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Category(
                    name: category.name,
                    categoryName: category.name, // Passing the category name
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: category.imagePath.isNotEmpty
                        ? Image.network(
                            category.imagePath,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 70);
                            },
                          )
                        : const Icon(Icons.image, size: 70),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ),
),

     const SizedBox(height: 20.0),
          const Text(
            "Recommendations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('cars').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No cars found.'));
      }

      final cars = snapshot.data!.docs.where((doc) {
        final carData = doc.data() as Map<String, dynamic>;
        final name = (carData['name'] ?? '').toLowerCase();
        return name.contains(searchText);
      }).toList();

      if (cars.isEmpty) {
        return const Center(child: Text('No matching cars found.'));
      }

      return ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final car = cars[index];
          final carData = car.data() as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetails(car: carData),
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: carData['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          carData['image'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.car_repair),
                        ),
                      )
                    : const Icon(Icons.car_repair, size: 40),
                title: Text(
                  carData['name'] ?? 'Unknown name',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  '${carData['model'] ?? 'Unknown model'} - ${carData['year'] ?? 'Unknown year'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.blue[700],
                ),
              ),
            ),
          );
        },
      );
    },
  ),
),

        ],
      ),
    );
  }
}

