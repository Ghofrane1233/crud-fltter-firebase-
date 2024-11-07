// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:version2/auth/login.dart';
import 'package:version2/auth/signup.dart';
import 'package:version2/homepage.dart';
import 'package:version2/pages/AddProduct.dart';
import 'package:version2/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCPzkcXQ9fj22-0jSeKmflpRMu9NPT2hmQ", 
      appId: "com.example.version2", 
      messagingSenderId: "messagingSenderId", 
      projectId: "formation-3cfae",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Added const to constructor

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState(); // Ensure super.initState() is called first
  }

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
    // Add more products as needed
  ];

  final List<Map> imageUrls = [
    {'link': "assets/Group-1.png", 'price': 15, 'name': 'Aymen'},
    {'link': "assets/Group-2.png", 'price': 20, 'name': 'Ali'},
    {'link': "assets/Group-3.png", 'price': 25, 'name': 'Kadhem'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        "signup": (context) => const Signup(),
        "homePage": (context) => Homepage(userId:''),
        "login": (context) => const Login(),
        "AddProduct":(context) => AddProduct(),
        "profile":(context) => profile(userId: "")
      },
    );
  }
}

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
