
import 'package:carring_crates/complaints.dart';
import 'package:carring_crates/donatenow.dart';
import 'package:carring_crates/feedback.dart';
import 'package:carring_crates/login.dart';
import 'package:carring_crates/myprofile.dart';
import 'package:carring_crates/myrequest.dart';
import 'package:carring_crates/orphanagerequest.dart';
import 'package:carring_crates/postcomplaint.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;


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
        setState(() {
          name = querySnapshot.docs.first['user_name'];
        });
        print(name);
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
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 50,
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfile()),
                );
              },
            ),
            ListTile(
              title: const Text('Feedback'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        width: 500,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0)),
        child: ListView(children: [
          const Text(
            'Caring Crates',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset("assets/orphanage.jpeg"),
          const SizedBox(
            height: 20,
          ),
          const Text('Hello,',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text(name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DonateNow()));
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const DonateNow()));
                    },
                    child: Container(
                      color: Colors.cyan,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Donate Now',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 244, 246, 246),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DonationsPage()));
                    },
                    child: Container(
                      color: Colors.cyan,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'My Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 244, 248, 248),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyRequest()));
                    },
                    child: Container(
                      color: Colors.cyan,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Orphanage Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
