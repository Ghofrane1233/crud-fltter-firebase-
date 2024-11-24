// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:version2/auth/login.dart';
import 'package:version2/auth/signup.dart';
import 'package:version2/pages/AddCarPage.dart';
// import 'package:version2/pages/AddProduct.dart';
import 'package:version2/pages/Home.dart';
import 'package:version2/pages/profile.dart';
import 'package:version2/pages/homepage.dart'; // Assurez-vous que la classe `Homepage` existe ici.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCPzkcXQ9fj22-0jSeKmflpRMu9NPT2hmQ", 
      appId: "1:1234567890:android:abcdef123456", // Remplacez par votre valeur.
      messagingSenderId: "1234567890", // Remplacez par votre valeur.
      projectId: "formation-3cfae",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Ajout de const pour un widget immuable

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // Liste des produits
  final List<Product> products = [
    Product(
      imageUrl: 'assets/Group-1.png',
      price: '\$29.99',
      rating: 4.5,
    ),
    Product(
      imageUrl: 'assets/Group-2.png',
      price: '\$19.99',
      rating: 4.0,
    ),
    Product(
      imageUrl: 'assets/Group-3.png',
      price: '\$39.99',
      rating: 4.8,
    ),
    // Ajoutez d'autres produits ici
  ];

  // Liste des données pour les images
  final List<Map> imageUrls = [
    {'link': "assets/Group-1.png", 'price': 15, 'name': 'Aymen'},
    {'link': "assets/Group-2.png", 'price': 20, 'name': 'Ali'},
    {'link': "assets/Group-3.png", 'price': 25, 'name': 'Kadhem'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Index(),
      routes: {
        "signup": (context) => Signup(),
         "login": (context) => Login(),
        // "AddProduct": (context) => AddProduct(),
        "profile": (context) => Profile(userId: ""), 
      'admin': (context) => AddCarPage(),
      'user': (context) => Home(),
      },
    );
  }
}

// Classe représentant un produit
class Product {
  final String imageUrl;
  final String price;
  final double rating;

  Product({
    required this.imageUrl,
    required this.price,
    required this.rating,
  });
}
