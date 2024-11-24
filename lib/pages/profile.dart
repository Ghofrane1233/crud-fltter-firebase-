import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'personaldatapage.dart';
import 'community.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({super.key, required this.userId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _result = '';

  @override
  void initState() {
    super.initState();
    fetchDataById(widget.userId); // Fetch data when the state is initialized
  }

  Future fetchDataById(String userId) async {
    print(userId);
    // Fetch the user data from Firestore using the userId.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)  // Fetch specific document using userId
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        setState(() {
          _result = doc['name']; // Extracting 'name' field from the document
        });
      } else {
        print("User not found");
      }
    });
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
                        MaterialPageRoute(builder: (context) =>  PersonalDataPage()), // Ensure PersonalDataPage is a const constructor
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
                        MaterialPageRoute(builder: (context) =>  Community()),
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
      child: const Row(
        children: [
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
