import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/pages/authentication/signin.dart';

import '../../utils/colors.dart';
import '../splash_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailControllerLogin = TextEditingController();
  final passwordControllerLogin = TextEditingController();

  showNormalSnackBar(BuildContext context,String snackBarText) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            dismissDirection: DismissDirection.horizontal,
            margin: const EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            content: Text(snackBarText)
        )
    );
  }
  showErrorSnackBar(BuildContext context,String snackBarText){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            dismissDirection: DismissDirection.horizontal,
            margin: const EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            backgroundColor: errorRed,
            content: Text(snackBarText)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 10),
                  child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/travel-companion-374f9.appspot.com/o/Logo.jpeg?alt=media&token=ad36063c-7e43-4ce4-ba50-fc36c5768747",
                    width: MediaQuery.of(context).size.width,
                  )
              ),
              Expanded(child: SizedBox()),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Sign In using your institute Id",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                height: 60,
                child: TextFormField(
                  controller: emailControllerLogin,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                    ),
                    fillColor: textFieldBackgroundColor,
                    filled: true
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                height: 60,
                child: TextFormField(
                  obscureText: true,
                  controller: passwordControllerLogin,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none
                      ),
                      fillColor: textFieldBackgroundColor,
                      filled: true
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                width: MediaQuery.of(context).size.width - 100,
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    if (emailControllerLogin.text.endsWith('@iitj.ac.in')){
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailControllerLogin.text,
                          password: passwordControllerLogin.text
                      ).then((_) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                      }).catchError((error) {
                        if (error.toString().contains('incorrect')){
                          showErrorSnackBar(context, 'Incorrect Email or Password');
                        } else {
                          showErrorSnackBar(context, 'Error $error');
                        }
                      });
                    }
                    else {
                      showErrorSnackBar(context, 'Use an email-id of IIT Jodhpur');
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 20,color: buttonTextColor),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
                      },
                      child: Text("Sign In using Google")
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
