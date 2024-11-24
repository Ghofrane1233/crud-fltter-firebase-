import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Ajout de l'importation manquante
import 'package:version2/components/button.dart';
import 'package:version2/pages/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Index(), // Correction du nom de la classe
    );
  }
}

void onPressed(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Home()),
  );
}

class Index extends StatelessWidget { // Correction du nom de la classe
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Welcome to Renty Car',
                      textStyle: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 2000),
                  displayFullTextOnTap: true,
                ),
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/car_logo.png', // Assurez-vous d'avoir ajouté une image dans le dossier `assets`
                height: 150,
              ),
             
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90.0),
                  child: CustomButton(
                    buttonText: "Get Started",
                    onPressed: () => onPressed(context),
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
