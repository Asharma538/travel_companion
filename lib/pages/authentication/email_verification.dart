import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/main.dart';
import 'dart:async';
import 'package:travel_companion/pages/authentication/login.dart';
import 'package:travel_companion/pages/authentication/signup.dart';
import 'package:travel_companion/utils/colors.dart';

final formkey = GlobalKey<FormState>();

class VerifyPage extends StatefulWidget {
  final String? email;

  const VerifyPage({Key? key, this.email}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  var state = 0;
  final emailController = TextEditingController();
  RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9_.&|^$#]+@iitj\.ac\.in$');
  bool _validate = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (state == 0) ...[
                _body(context, emailController),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(context, TextEditingController email) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 150, 0, 10),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Email verification link has been to your email",
                style: TextStyle(
                  color: headingTextColor,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser!.reload();
                try {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification send again'))
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sending verification link'))
                  );
                }
              },
              child: Text("Resend link")
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser!.reload();
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Base())
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User Verified succesfully'))
                  );
                } else {
                  print("Timeout error re verify the user");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage())
                  );
                  FirebaseAuth.instance.currentUser!.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error verifing user,kindly reverify"))
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 25, color: buttonTextColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
