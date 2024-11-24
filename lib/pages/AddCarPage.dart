import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final _carNameController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carImageController = TextEditingController();
  final _carDescriptionController = TextEditingController();

  Future<void> _addCarToFirebase() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('cars').add({
          'name': _carNameController.text,
          'model': _carModelController.text,
          'year': int.parse(_carYearController.text),
          'description': _carDescriptionController.text,
          'image': _carImageController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Voiture ajoutée avec succès !')),
        );

        // Réinitialiser le formulaire après soumission
        _formKey.currentState!.reset();
        _carNameController.clear();
        _carModelController.clear();
        _carYearController.clear();
        _carImageController.clear();
        _carDescriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'ajout de la voiture : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une voiture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ pour le nom de la voiture
              TextFormField(
                key: const Key('carNameField'),
                controller: _carNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de la voiture',
                  hintText: 'Ex: Toyota Corolla',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de la voiture.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ pour le modèle de la voiture
              TextFormField(
                key: const Key('carModelField'),
                controller: _carModelController,
                decoration: const InputDecoration(
                  labelText: 'Modèle de la voiture',
                  hintText: 'Ex: Corolla',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le modèle de la voiture.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ pour l'année de la voiture
              TextFormField(
                key: const Key('carYearField'),
                controller: _carYearController,
                decoration: const InputDecoration(
                  labelText: 'Année',
                  hintText: 'Ex: 2020',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir l\'année.';
                  }
                  final year = int.tryParse(value);
                  if (year == null || year < 1886 || year > DateTime.now().year) {
                    return 'Veuillez saisir une année valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ pour l'URL de l'image
              TextFormField(
                key: const Key('carImageField'),
                controller: _carImageController,
                decoration: const InputDecoration(
                  labelText: 'URL de l\'image',
                  hintText: 'Ex: https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une URL d\'image.';
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return 'Veuillez saisir une URL valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Champ pour la description
              TextFormField(
                key: const Key('carDescriptionField'),
                controller: _carDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Ex: Voiture confortable et économique.',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bouton pour ajouter la voiture
              ElevatedButton(
                onPressed: _addCarToFirebase,
                child: const Text('Ajouter la voiture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
