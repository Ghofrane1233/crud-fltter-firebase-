import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:version2/components/TextFormField.dart'; 
import 'personaldatapage.dart';
import 'community.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class profile extends StatefulWidget {
  final String userId;

  const profile({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _profileState createState() => _profileState();
}

// ignore: camel_case_types
class _profileState extends State<profile> {
  String _result = '';

  @override
  void initState() {
    super.initState();
    fetchDataById(widget.userId); // Fetch data when the state is initialized
  }

  Future fetchDataById(String userId) async {
    // ignore: avoid_print
    print(userId);
    await FirebaseFirestore.instance
    .collection('users')
    .get()
    .then((QuerySnapshot querySnapshot) {
        // ignore: avoid_function_literals_in_foreach_calls
        querySnapshot.docs.forEach((doc) {
            // ignore: avoid_print
            print(doc["name"]);
                setState(() {
        _result = doc['name'];
      });     
        });
    });
    // DocumentSnapshot doc = 
    // await FirebaseFirestore.instance.collection('users').doc(userId).get().then((DocumentSnapshot documentSnapshot) {
    //   print(documentSnapshot.data());
    //    if (documentSnapshot.exists) {
    //     print('Document exists on the database');
    //   }
    // });
    // if (doc.exists) {
    //   return doc['name']; // Replace 'name' with the actual field name you want to retrieve
    // } else {
    //   throw Exception('Document non trouvé');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/user.jpeg', height: 40), // Ensure the path is correct
            const SizedBox(width: 8), // Add spacing between image and text
            Text(_result),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate back to the login screen
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(color: Colors.grey, thickness: 1, height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.user,
                    text: 'Personal Data',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PersonalDataPage()), // Ensure PersonalDataPage is a const constructor
                      );
                    },
                  ),
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.cog,
                    text: 'Settings',
                  ),
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.fileAlt,
                    text: 'E-Statement',
                  ),
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.heart,
                    text: 'Referral Code',
                  ),
                  const Divider(color: Colors.grey, thickness: 1, height: 20),
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.ellipsisH,
                    text: 'FAQs',
                  ),
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.pencilAlt,
                    text: 'Our Handbook',
                  ),
                  _buildIconTextRow(
                    icon: FontAwesomeIcons.users,
                    text: 'Community',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Community()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create rows with an icon and text.
  Widget _buildIconTextRow({required IconData icon, required String text, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background
                borderRadius: BorderRadius.circular(8),
              ),
              child: FaIcon(
                icon,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create the information card at the bottom.
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 201, 213, 255),
        borderRadius: BorderRadius.circular(8.0),
      ),
      // ignore: prefer_const_constructors
      child: Row(
        children: const [
          FaIcon(
            FontAwesomeIcons.headphonesAlt,
            color: Colors.blue,
            size: 30,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Text(
              "Feel Free To Ask. We’re Ready To Help",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
