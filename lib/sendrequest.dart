import 'package:carring_crates/myprofile.dart';
import 'package:flutter/material.dart';

class SendRequest extends StatefulWidget {
  const SendRequest({Key? key}) : super(key: key);

  @override
  State<SendRequest> createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  String? selectedDonationtype;
  List<String> Donationtype = ['Food', 'Pillows', 'Blankets', 'Education', 'Medical Support'];

  void sendRequest() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with sending the request
      print(_titleController.text);
      print(_detailsController.text);
      // Perform other actions related to sending the request

      // After successful submission, clear the form
      _formKey.currentState!.reset();
      selectedDonationtype = null;
    }
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
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Send Request',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const SizedBox(width: 100, child: Text('Donation Type')),
                  Flexible(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: selectedDonationtype,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDonationtype = newValue;
                        });
                      },
                      isExpanded: true,
                      items: Donationtype.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  hintText: 'Details',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: sendRequest,
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

