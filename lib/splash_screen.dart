import 'package:carring_crates/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    gotoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
            child: Text(
          'CARING CRATES',
          style: TextStyle(
              fontSize: 45.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w900,
              color: Colors.deepPurpleAccent),
        )),
      ),
    );
  }

  void gotoLogin() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login(),
          ));
    });
  }
}
