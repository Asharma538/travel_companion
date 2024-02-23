import 'package:flutter/material.dart';
import 'dart:async';
import 'package:travel_companion/pages/authentication/email_verification.dart';
import 'package:travel_companion/pages/authentication/login.dart';
import '../../main.dart';
import '../../pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final formkey = GlobalKey<FormState>();

class SignupPage extends StatelessWidget {
  final String? signUpEmail;

  const SignupPage({Key? key, this.signUpEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignupPageBody(signUpEmail: signUpEmail),
    );
  }
}

class SignupPageBody extends StatefulWidget {
  final String? signUpEmail;

  const SignupPageBody({Key? key, this.signUpEmail}) : super(key: key);

  @override
  State<SignupPageBody> createState() => SignupBodyState();
}

class SignupBodyState extends State<SignupPageBody> {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.signUpEmail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: _body(
            context,
            userNameController,
            emailController,
            passwordController,
            confirmPasswordController,
            phoneNumberController),
      ),
    );
  }

  _body(
    context,
    TextEditingController username,
    TextEditingController email,
    TextEditingController password,
    TextEditingController confirmPassword,
    TextEditingController phoneNumber,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: const Text(
                "SIGN UP",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formkey,
            child: Column(children: [
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    fillColor: textFieldBackgroundColor,
                    filled: true,
                  ),
                  validator: (username) =>
                      username!.isEmpty ? 'This field is required' : null,
                ),
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    fillColor: textFieldBackgroundColor,
                    filled: true,
                  ),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "This field is required";
                    } else if (!email.contains(
                        RegExp(r'^[a-zA-z0-9._$#|@^&]+@iitj\.ac\.in$'))) {
                      return "Enter a Valid Email";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    fillColor: textFieldBackgroundColor,
                    filled: true,
                    // prefixIcon: const Icon(Icons.person)
                  ),
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "This field is required";
                    } else if (password.length < 6) {
                      return "Password must be at least 6 characters long";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 80,
                child: TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    fillColor: textFieldBackgroundColor,
                    filled: true,
                  ),
                  validator: (confirmPassword) {
                    if (confirmPassword == null || confirmPassword.isEmpty) {
                      return "This feild is required";
                    } else if (confirmPassword != passwordController.text) {
                      return "Confirm the same password";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {},
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: PhoneNumber(isoCode: 'IN'),
                  textFieldController: phoneNumber,
                  formatInput: false,
                  validator: (String? val) {
                    if (val == "" || val == null) {
                      return "Phone Number is needed";
                    } else if (val.length < 10) {
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                ),
              ),
            ]),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: linkTextColor),
                  ))
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: ElevatedButton(
              onPressed: () async {
                formkey.currentState!.validate();

                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email.text, password: password.text)
                    .then((credential) async {
                  try {
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Verification link sent successfully')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Error sending link, please check the email provided')));
                  }

                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(credential.user?.email)
                      .set({
                    'username': username.text,
                    'phoneNumber': phoneNumber.text,
                    "email": email.text,
                    'profilePhotoState': 0,
                    'about': "Not Available"
                  });

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => VerifyPage()));
                }).catchError((e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  } else if (e.code == 'email-already-in-use') {
                    print("User already in use");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'User already exists! Please try logging in')));
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                });
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
          )
        ],
      ),
    );
  }
}
