// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:version2/components/TextFormField.dart';
import 'package:version2/homepage.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String _message = '';


  @override
  void initState() {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // ignore: avoid_print
        print('User is currently signed out!');
      } else {
        // ignore: avoid_print
        print('User is signed in!');
        Navigator.of(context).pushNamed('homePage');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'Email',
                      mycontroller: emailController,
                      isObscure: false, // Changed to false for email field
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      hintText: 'Password',
                      mycontroller: passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // Add your forgot password logic here
                      },
                      child: const Text("Forgot Password?"),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 18, 119, 212),
                ),
                onPressed: () async {
                  // Validate email and password
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    setState(() {
                      _message = 'Please fill the Textfields.';
                    });
                    return;
                  }

                  try {
                    // Attempt to sign in
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    String uid = credential.user!.uid;

                    // Navigate to Home after successful login
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(userId:uid), // Pass uid and userName here
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      // Set error messages based on exception
                      if (e.code == 'user-not-found') {
                        _message = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        _message = 'Wrong password provided for that user.';
                      } else {
                        _message = 'An error occurred. Please try again.';
                      }
                    });
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  // Add login with Google logic here
                },
                child: const Text(
                  "Login with Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Signup()),
                  );
                },
                child: const Text("Don't have an account? Sign up here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
