import 'package:flutter/material.dart';

void main() {
  runApp(PersonalDataPage());
}

class PersonalDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemple de Page Flutter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Bienvenue sur ma page!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // Espace entre les éléments
              ElevatedButton(
                onPressed: () {
                  // Action à effectuer lors de l'appui sur le bouton
                },
                child: const Text('Cliquez ici'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
