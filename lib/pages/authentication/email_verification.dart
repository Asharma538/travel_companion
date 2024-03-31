import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/main.dart';
import 'package:travel_companion/pages/authentication/signup.dart';
import 'package:travel_companion/utils/colors.dart';
import 'package:http/http.dart' as http;

import '../profile.dart';

final formkey = GlobalKey<FormState>();

class VerifyPage extends StatefulWidget {
  final String? email;

  const VerifyPage({Key? key, this.email}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState(email);
}

class _VerifyPageState extends State<VerifyPage> {
  String? email;

  _VerifyPageState(this.email);

  showNormalSnackBar(BuildContext context, String snackBarText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(5),
        behavior: SnackBarBehavior.floating,
        content: Text(snackBarText)
      )
    );
  }

  showErrorSnackBar(BuildContext context, String snackBarText){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: errorRed,
        content: Text(snackBarText)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          child: _body(context, email),
        ),
      ),
    );
  }

  Widget _body(context, String? email) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
            alignment: Alignment.center,
            child: const Text(
              "Email Verification",
              style: TextStyle(
                color: headingTextColor,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            alignment: Alignment.center,
            child: const Text(
              'Please check the email sent to',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              email!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () async {
                      try {
                        FirebaseAuth.instance.currentUser!
                            .sendEmailVerification();
                        showNormalSnackBar(
                            context, 'Verification email sent again');
                      } catch (e) {
                        showErrorSnackBar(
                            context, 'Error sending verification link $e');
                      }
                    },
                    child: const Text("Resend link")),
              ),
              
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () async {
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    child: const Text("Change Email")),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              onPressed: () async {
                FirebaseAuth.instance.currentUser!.reload();
                String uid = FirebaseAuth.instance.currentUser!.uid;
                http.get(Uri.parse('https://travel-companion-dev-jaea.2.sg-1.fl0.io/verify?uid=$uid'))
                    .then((value) {
                  Map<String, dynamic> response = jsonDecode(value.body);
                  if (response.containsKey('data') &&
                      response['data'] == 'User Verified') {
                    showNormalSnackBar(context, response['data']);
                    FirebaseAuth.instance.currentUser!.reload();
                    FirebaseAuth.instance.currentUser?.getIdToken(true);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Base()),
                        (route) => false);
                  } else if (response.containsKey('error')) {
                    showErrorSnackBar(context, response['error']);
                  } else {
                    showNormalSnackBar(context, response['data']);
                  }
                }).catchError((error) {
                  showErrorSnackBar(context, 'Error: $error');
                });
              },
              style: TextButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 22, color: buttonTextColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
