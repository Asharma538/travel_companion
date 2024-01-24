import 'package:flutter/material.dart';
import 'package:travel_companion/pages/email_verification.dart';
// import 'package:travel_companion/pages/spash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VerifyPage(),
  ));
}
