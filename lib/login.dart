import 'package:carring_crates/dashboard.dart';
import 'package:carring_crates/forgot_password.dart';
import 'package:carring_crates/registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

      Future<int?> fetchStudentStatus(String studentId) async {
    try {
      print('student id: $studentId');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('tbl_userregistration')
              .where('User_id', isEqualTo: studentId)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming 'student_status' is a String field, adjust accordingly
        return 1;
      } else {
        print('No document found with Student_id $studentId.');
        return null;
      }
    } catch (e) {
      print('Error fetching student status: $e');
      return null;
    }
  }

  Future<void> Login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String? userId = userCredential.user?.uid;
      if (userId != null) {
        int? studentStatus = await fetchStudentStatus(userId);
        if (studentStatus != null) {
         

          if (studentStatus == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Dashboard(),
                ));
           
          }  else {
             Fluttertoast.showToast(
              msg: 'Invalid Credential',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        } else {
          

          print('Failed to fetch student status.');
        }
      }

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      } catch (e) {
        // Handle login failure and show an error toast.
        String errorMessage = 'Login failed';

        if (e is FirebaseAuthException) {
          errorMessage = e.code;
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                'Login',
                style: TextStyle(fontSize: 25.0, fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Enter Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!_emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Enter Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Text('Forgot Password ',
                    style: TextStyle(fontSize: 10.0)),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: Login,
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Registration()));
                },
                child: const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 10.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
