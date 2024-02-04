import 'package:flutter/material.dart';
import '../../main.dart';
import '../../pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../utils/colors.dart';

class SignupPage extends StatefulWidget {
 final String? signUpEmail;

  const SignupPage({Key? key, this.signUpEmail}) : super(key: key);

  @override
  State<SignupPage> createState() => Signup();
}

class Signup extends State<SignupPage> {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var phoneNumberController= TextEditingController();

  @override
    void initState() {
      super.initState();
      emailController.text = widget.signUpEmail ?? '';
    }
  
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: primaryColor,
        body: _body(context, userNameController, emailController ,passwordController, confirmPasswordController,phoneNumberController),
      ),
    );
  }

  _body (context, TextEditingController username, TextEditingController email,
      TextEditingController password, TextEditingController confirm_password, TextEditingController phoneNumber,) {
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
          Column(children: [
            SizedBox(
              height: 80,
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  ),
                  fillColor: textFieldBackgroundColor,
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: TextField(
                controller: email,
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  ),
                  fillColor: textFieldBackgroundColor,
                  filled: true,
                  // prefixIcon: const Icon(Icons.person)
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  ),
                  fillColor: textFieldBackgroundColor,
                  filled: true,
                  // prefixIcon: const Icon(Icons.person)
                ),
              ),
            ),
            SizedBox(
              height: 80,
              child: TextField(
                controller: confirm_password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor: textFieldBackgroundColor,
                  filled: true,
                  // prefixIcon: const Icon(Icons.person)
                ),
              ),
            ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber); 
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: PhoneNumber(isoCode: 'IN'),
                  textFieldController: phoneNumber,
                  formatInput: false,
                ),
              ),
            ]),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height / 10,
            child: ElevatedButton(
              onPressed: () async {
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email.text, password: password.text
                  ).then((_) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Base()));
                  }).catchError((e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
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
