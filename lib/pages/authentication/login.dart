import 'package:flutter/material.dart';
import 'package:travel_companion/pages/authentication/email_verification.dart';
import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/colors.dart';

final loginFormKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _body(context, emailController, passwordController),
              ],
            ),
          ),
        ),
      );
  }

  _body(context, TextEditingController email, TextEditingController password) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 150),
            alignment: Alignment.center,
            child: const Text(
              "LOGIN",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              Container(alignment: Alignment.centerLeft, child: const Text('Email')),
              SizedBox(
                height: 80,
                child: Form(
                  key: loginFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none),
                      fillColor: textFieldBackgroundColor,
                      filled: true,
                    ),
                    validator: (emailIp){
                      if (emailIp!.contains(RegExp(r'^[a-zA-z0-9._$#|@^&]+@iitj\.ac\.in$'))) {
                        return null;
                      } else {
                        return "Enter a valid email";
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Password'),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: linkTextColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none),
                    fillColor: textFieldBackgroundColor,
                    filled: true,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 15),
            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const VerifyPage()));
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(color: linkTextColor),
                    ))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30, top: 10),
              width: MediaQuery.of(context).size.width - 80,
              height: 50,
              child: TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: email.text, password: password.text)
                        .then((_) {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Base()));
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
                style: TextButton.styleFrom(backgroundColor: secondaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 22, color: buttonTextColor),
                ),
              ),
          ),
        ],
      ),
    );
  }
}