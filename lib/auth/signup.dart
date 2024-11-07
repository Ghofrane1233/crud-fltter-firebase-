import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:version2/components/TextFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  // ignore: use_super_parameters
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
  }

  Future<void> addUser(String name, String phone, String email) async {
    try {
      await _firestore.collection('users').add({
        'name': name,
        'phone': phone,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User added successfully!")),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add user: $e")),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await registerUser();
      await addUser(
        _nameController.text,
        _phoneController.text,
        _emailController.text,
      );

      // Clear the form fields after submission
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return null;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // ignore: avoid_print
      print('Google sign-in failed: $e');
      return null;
    }
  }

  Future<void> registerUser() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // ignore: avoid_print
        print('User created: ${credential.user?.uid}');
        await credential.user?.sendEmailVerification();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed("login");
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          // ignore: avoid_print
          print("The account already exists for that email.");
        } else {
          // ignore: avoid_print
          print("Error: ${error.message}");
        }
      }
    } else {
      // ignore: avoid_print
      print("Passwords do not match.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, right: 30, left: 30),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    hintText: 'Name',
                    mycontroller: _nameController,
                    isObscure: false,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CustomTextFormField(
                      hintText: 'Email',
                      mycontroller: _emailController,
                      isObscure: false,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CustomTextFormField(
                      hintText: 'Phone',
                      mycontroller: _phoneController,
                      isObscure: false,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CustomTextFormField(
                      hintText: 'Password',
                      mycontroller: _passwordController,
                      isObscure: true,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CustomTextFormField(
                      hintText: 'Confirm Password',
                      mycontroller: _confirmPasswordController,
                      isObscure: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.blue[400],
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Signup"),
                    onPressed: () async {
                      await _submitForm();
                    },
                  ),
                  MaterialButton(
                    color: Colors.blue[400],
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Sign In With Google"),
                    onPressed: () async {
                      await signInWithGoogle();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
