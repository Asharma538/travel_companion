import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/main.dart';
import 'package:travel_companion/pages/authentication/email_verification.dart';
import 'package:travel_companion/pages/home.dart';
import 'package:travel_companion/pages/profile.dart';
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
    Timer(Duration(milliseconds: 1500), () async {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Base())
        );
      } else if ( FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VerifyPage(email: FirebaseAuth.instance.currentUser!.email,)));
      }
      else {
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
                width: MediaQuery.of(context).size.width,
              )),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: const Text(
                  'Discover New Buddies !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
