import 'package:flutter/material.dart';
import 'package:travel_companion/pages/authentication/signup.dart';
import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/colors.dart';

final loginFormKey = GlobalKey<FormState>();

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key});

  
  Future sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      print("hi");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reset password link sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
      showNormalSnackBar(context, (e.message.toString()));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error ocurred'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  showNormalSnackBar(BuildContext context, String snackBarText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(5),
        behavior: SnackBarBehavior.floating,
        content: Text(snackBarText)));
  }

  showErrorSnackBar(BuildContext context, String snackBarText) {
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
          Column(children: [
            Container(
                alignment: Alignment.centerLeft, child: const Text('Email')),
            SizedBox(
              height: 80,
              child: Form(
                key: loginFormKey,
                autovalidateMode: AutovalidateMode.disabled,
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
                  validator: (emailIp) {
                    emailIp = emailIp!.trim();
                    if (emailIp!.contains(
                        RegExp(r'(?i)^[a-zA-z0-9._$#|@^&]+@iitj\.ac\.in$'))) {
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
                  onPressed: () {
                    sendPasswordResetEmail(context, emailController.text);
                  },
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()));
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
                loginFormKey.currentState!.validate();
                try {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text.trim(), password: password.text)
                      .then((_) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Base()));
                  }).catchError((error) {
                    if ((error.toString()).contains('incorrect')) {
                      showErrorSnackBar(context, 'Incorrect Email or Password');
                    } else {
                      showErrorSnackBar(context, 'Error $error');
                    }
                  });
                } catch (error) {
                  showErrorSnackBar(context, 'Error $error');
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
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
