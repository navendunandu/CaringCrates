import 'package:carring_crates/changepassword.dart';
import 'package:carring_crates/editprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  String name = 'Loading...';
  String email = 'Loading...';
  String contact = 'Loading...';
  String address = 'Loading...';
  String image = '';

  Future<void> loadData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_userregistration')
              .where('User_id', isEqualTo: userId)
              .limit(1)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          name = doc['user_name'] ?? 'Error Loading Data';
          email = doc['user_email'] ?? 'Error Loading Data';
          contact = doc['user_contact'] ?? 'Error Loading Data';
          address = doc['user_address'] ?? 'Error Loading Data';
          image = doc['user_photo'];
        });
      } else {
        setState(() {
          name = 'Error Loading Data';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: 500,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.0)),
          child: ListView(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundColor: const Color(0xff4c505b),
                backgroundImage: image.isNotEmpty
                    ? NetworkImage(image) as ImageProvider
                    : const AssetImage('assets/pic_11.png'),

              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'My Profile',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              Text('Name: $name'),
              const SizedBox(
                height: 20,
              ),
              Text('Email: $email'),
              const SizedBox(
                height: 20,
              ),
              Text('Contact: $contact'),
              const SizedBox(
                height: 20,
              ),
              Text('Address: $address'),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Editprofile(),
                        ));
                  },
                  child: const Text('Edit Profile')),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ));
                  },
                  child: const Text('Change Password'))
            ],
          ),
        ),
      ),
    );
  }

  void gotoeditprofile() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Editprofile(),
        ));
  }

  void gotchangepassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangePassword(),
        ));
  }
}
