import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:version2/pages/Resrvation.dart';

class Category extends StatefulWidget {
  final String categoryName;

  Category({Key? key, required this.categoryName, required String name}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late FirebaseFirestore _firestore;
  late Stream<QuerySnapshot> _carsStream;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;

    // Filtrer les voitures par catégorie
    _carsStream = _firestore
        .collection('cars') // Nom de la collection dans Firestore
        .where('category', isEqualTo: widget.categoryName) // Filtre sur le nom de la catégorie
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Couleur personnalisée
        title: Text(
          "Cars in ${widget.categoryName} Category",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _carsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No cars found in this category.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          var cars = snapshot.data!.docs;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              var car = cars[index];
              var carData = car.data() as Map<String, dynamic>; // Conversion nécessaire
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5, // Ombre pour un effet de profondeur
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
                      : const Icon(Icons.car_repair, size: 60),
                  title: Text(
                    carData['name'] ?? 'Unknown name',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    '${carData['model'] ?? 'Unknown model'} - ${carData['year'] ?? 'Unknown year'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationPage(),
                    ),
                  );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
