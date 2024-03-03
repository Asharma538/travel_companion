import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/main.dart';
import 'package:travel_companion/pages/home.dart';
import 'authentication/signup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() {
    Timer(Duration(milliseconds: 1500), () {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Base()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignupPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/Logo.jpeg?alt=media&token=ad36063c-7e43-4ce4-ba50-fc36c5768747",
                width: MediaQuery.of(context).size.width - 100,
              )),
              const Text(
                '<Caption>',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
