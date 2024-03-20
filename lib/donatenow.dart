// ignore_for_file: avoid_print

import 'package:carring_crates/myprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DonateNow extends StatefulWidget {
  const DonateNow({super.key});

  @override
  State<DonateNow> createState() => _DonatenowState();
}

class _DonatenowState extends State<DonateNow> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  List<Map<String, dynamic>> donationType = [];

  String? _selectedDonation;

  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fetchDonationType() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await db.collection('tbl_donationtype').get();

      List<Map<String, dynamic>> dist = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'donationtype_name': doc['donationtype_name'].toString(),
              })
          .toList();
      setState(() {
        donationType = dist;
      });
    } catch (e) {
      print('Error fetching donation type data: $e');
    }
  }

  Future<void> donate() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final DateTime now = DateTime.now();
    final String formattedDate = '${now.year}-${now.month}-${now.day}';
    try {
      final data = <String, dynamic>{
        'date': formattedDate,
        'description': _descController.text,
        'title': _titleController.text,
        'donation_status': 0,
        'orphnage_id': '',
        'user_id': userId,
        'donationtype_id': _selectedDonation,
      };
      await db
          .collection('tbl_donation')
          .add(data)
          .then((DocumentReference doc) => Fluttertoast.showToast(
                msg: 'Thank You for your Donation',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ));
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      print('Donation Error: $e');
      Fluttertoast.showToast(
        msg: 'Donation Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDonationType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyProfile()),
              );
            },
            icon: const Icon(Icons.person), // Replace with the desired icon
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: 500,
          width: 500,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.0)),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              const Text(
                'Donate Now',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Enter Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _descController,
                decoration:
                    const InputDecoration(hintText: 'Enter Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              DropdownButtonFormField<String>(
                value: _selectedDonation,
                decoration: const InputDecoration(
                  hintText: 'Select Donation Type',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDonation = newValue!;
                  });
                },
                isExpanded: true,
                items: donationType.map<DropdownMenuItem<String>>(
                  (Map<String, dynamic> dt) {
                    return DropdownMenuItem<String>(
                      value: dt['id'], // Use document ID as the value
                      child: Text(dt['donationtype_name']),
                    );
                  },
                ).toList(),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      donate();
                    }
                  },
                  child: const Text('Donate'))
            ]),
          ),
        ),
      ),
    );
  }
}
