import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:travel_companion/pages/authentication/login_page.dart';
import 'package:travel_companion/pages/splash_screen.dart';
import '../../utils/colors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(hostedDomain: 'iitj.ac.in');
  late GoogleSignInAccount _userObj;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      FirebaseFirestore.instance.collection('Users').doc(_userObj.email).set({
        'username': user?.displayName,
        "email": user?.email,
        'profilePhotoState': 0,
        'about': "Add your about here"
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));

    } catch (e) {
      print(e.toString());
    }
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
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  "Sign In using your institute Id",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SignInButton(
                  shape:  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  Buttons.google,
                  text: "Sign In with Google",
                  onPressed: () {
                    _googleSignIn.signIn().then((userData) {
                      setState(() {
                        _userObj = userData!;
                        signInWithGoogle();
                      });
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: TextButton(
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text("Log In to an existing account")
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}