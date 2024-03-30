import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationsPage extends StatefulWidget {
  const DonationsPage({Key? key}) : super(key: key);

  @override
  _DonationsPageState createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  late Future<List<DocumentSnapshot>> _donationsFuture;

  @override
  void initState() {
    super.initState();
    _donationsFuture = _fetchDonations();
  }

  Future<List<DocumentSnapshot>> _fetchDonations() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    

    QuerySnapshot<Map<String, dynamic>> studentSnapshot =
        await FirebaseFirestore.instance
            .collection('tbl_userregistration')
            .where('User_id', isEqualTo: userId)
            .get();

    String documentId = studentSnapshot.docs.first.id;
    print(documentId);

    QuerySnapshot<Map<String, dynamic>> donationSnapshot =
        await FirebaseFirestore.instance
            .collection('tbl_donation')
            .where('user_id', isEqualTo: documentId)
            .get();

    return donationSnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _donationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No donations found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data![index];
              return ListTile(
                title: Text(document['title'] ?? ''),
                subtitle: Text(document['description'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
