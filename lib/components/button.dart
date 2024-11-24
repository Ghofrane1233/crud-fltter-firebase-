// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyPageWithFooterButton extends StatelessWidget {
  const MyPageWithFooterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page with Footer Button'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Main content of the page here
          Expanded(
            child: Center(
              child: Text('Main Content of the Page'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              buttonText: 'Footer Button',
              onPressed: () {
                // Action à exécuter lors du clic
                print("Button Pressed!");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2972FF),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 14,
        ),
      ),
    );
  }
}
