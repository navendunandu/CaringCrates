import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationsPage extends StatefulWidget {
  const DonationsPage({super.key});

  @override
  _DonationsPageState createState() => _DonationsPageState();
}

class _DonationsPageState extends State<DonationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      body: const DonationsList(),
    );
  }
}

class DonationsList extends StatelessWidget {
  const DonationsList({super.key});

  Future<String> getDonationTypeName(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('tbl_donationtype')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return data['donationtype_name'] ?? 'Unknown';
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      print('Error fetching donation type name: $e');
      throw Exception('Error fetching donation type name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tbl_donation').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return FutureBuilder<String>(
              future: getDonationTypeName(data['donationtype_id']),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text(data['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['description'], textAlign: TextAlign.left),
                        const CircularProgressIndicator(), // Show a loading indicator while waiting for the future to complete
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return ListTile(
                    title: Text(data['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['description'],
                          textAlign: TextAlign.left,
                        ),
                        const Text('Error fetching donation type',
                            textAlign: TextAlign.left),
                      ],
                    ),
                  );
                } else {
                  return ListTile(
                    title: Text(data['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['description'], textAlign: TextAlign.left),
                        Text(snapshot.data ?? 'Unknown',
                            textAlign: TextAlign
                                .left), // Display the fetched donation type name
                      ],
                    ),
                  );
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
