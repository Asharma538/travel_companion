import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_companion/pages/authentication/email_verification.dart';
import 'package:travel_companion/pages/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

final formKey = GlobalKey<FormState>();

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignupPageBody(),
    );
  }
}

class SignupPageBody extends StatefulWidget {
  const SignupPageBody({Key? key}) : super(key: key);

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
  }

  sendVerificationLink(String email, String password) async {
    await http
        .post(
            Uri.parse('https://travel-companion-dev-jaea.2.sg-1.fl0.io/signup'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "password": password}))
        .then((response) async {
      if (response.statusCode == 200) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
          print(FirebaseAuth.instance.currentUser);
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
        });
      } else {
        var res = jsonDecode(response.body)['data'] ?? '';
        throw Exception('Something went wrong ${res}');
      }
    }).catchError((error) {
      throw Exception('Error $error');
    });
  }

  createUserDocument(email, username, phoneNumber) {
    FirebaseFirestore.instance.collection('Users').doc(email).set({
      'username': username,
      "email": email,
      'profilePhotoState': 0,
      'about': "Not Available"
    });
    FirebaseFirestore.instance.collection('PhoneNumbers').doc(email).set({
      'phoneNumber': phoneNumber,
    });
    FirebaseFirestore.instance
        .collection('Requests')
        .doc(email)
        .set({'requests': []});
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
      TextEditingController phoneNumber) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              child: Container(
                margin: const EdgeInsets.only(top: 50, bottom: 80),
                alignment: Alignment.center,
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: formKey,
              child: Column(children: [
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    autocorrect: false,
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
                    autocorrect: false,
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
                      if (email!.isEmpty) {
                        return "This field is required";
                      } else if (!email.trim().contains(
                          RegExp(r'(?i)^[a-zA-z0-9._$#|@^&]+@iitj\.ac\.in$'))) {
                        return "Provide an IITJ Email";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    autocorrect: false,
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
                      } else if (password.length < 8) {
                        return "Password must be at least 8 characters long";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: TextFormField(
                    autocorrect: false,
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
                  height: 80,
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
                SizedBox(height: MediaQuery.of(context).size.height - 720),
              ]),
            ),
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
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                onPressed: () async {
                  formKey.currentState!.validate();

                  if (passwordController.text !=
                          confirmPasswordController.text ||
                      phoneNumberController.text.toString().length < 10 ||
                      phoneNumberController.text.toString().isEmpty ||
                      passwordController.text.length < 8 ||
                      !(emailController.text.trim().contains(
                          RegExp(r'^[a-zA-z0-9._$#|@^&]+@iitj\.ac\.in$')))) {
                    return;
                  }

                  try {
                    await sendVerificationLink(
                        email.text.trim(), password.text);
                    showNormalSnackBar(
                        context, 'Verification link sent successfully');
                  } catch (e) {
                    showErrorSnackBar(context,
                        'Error sending link, please recheck the email or try again in some time $e');
                  }

                  try {
                    createUserDocument(email.text.trim(), username.text.trim(),
                        phoneNumber.text.trim());
                  } catch (e) {
                    print(e);
                    showErrorSnackBar(context,
                        'Error creating User, please try again in some time');
                  }
                  // Going to verification page
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VerifyPage(email: email.text.trim())));
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
      ),
    );
  }
}
