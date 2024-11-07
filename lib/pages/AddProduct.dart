import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:version2/components/TextFormField.dart';

class Product {
  final String name;
  final String description;
  final double price;
 
  Product({
    required this.name,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    
    };
  }
}

class AddProduct extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();


  

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    try {
      // Parse the price
      final price = double.parse(_priceController.text);

    

      // Create product object and save to Firestore
      final product = Product(
        name: _nameController.text,
        description: _descriptionController.text,
        price: price,
     
      );

      await FirebaseFirestore.instance.collection('products').add(product.toMap());

      // Clear the form
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
     
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding product: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(hintText: "Product Name", mycontroller: _nameController, isObscure: true),
            CustomTextFormField(hintText: "Description", mycontroller: _descriptionController, isObscure: true),
            CustomTextFormField(hintText: "Price ", mycontroller: _priceController, isObscure: true )
            ,
          
            SizedBox(height: 20),
            ElevatedButton( 
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
