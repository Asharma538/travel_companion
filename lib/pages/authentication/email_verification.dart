import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
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
          margin: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (state == 0) ...[
                _body(context, emailController),
              ] else ...[
                _fillOTP(context, emailController),
              ]
            ],
          ),
        ),
      ),
    );
  }

  _body(context, TextEditingController email) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 150),
            child: Container(
              alignment: Alignment.topCenter,
              child: const Text(
                "Email Verification",
                style: TextStyle(
                  color: headingTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(children: [
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Enter your email',
                  style: TextStyle(
                      color: primaryTextColor, fontWeight: FontWeight.w400),
                )),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formkey,
              child: SizedBox(
                height: 80,
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: placeholderTextColor),
                    errorText: _validate ? "This field is required" : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none),
                    fillColor: textFieldBackgroundColor,
                    filled: true,
                  ),
                  validator: (email) {
                    if (email!
                        .contains(RegExp(r'^[a-zA-z0-9._$#|@^&]+@iitj\.ac\.in$'))) {
                      return null;
                    } else {
                      return "Enter a valid email";
                    }
                  },
                ),
              ),
            ),
          ]),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text(
                    "Login",style: TextStyle(color: linkTextColor),
                  )
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 10),
            width: MediaQuery.of(context).size.width - 80,
            height: 50,
            child: TextButton(
              onPressed: () {
                formkey.currentState!.validate();

                setState(() {
                  emailController.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
                if (_validate != true) {
                  setState(() {
                    state = 1;
                  });
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
                style: TextStyle(fontSize: 22, color: buttonTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _fillOTP(BuildContext context, TextEditingController email) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
              alignment: Alignment.topCenter,
              child: const Text(
                "Email Verification",
                style: TextStyle(
                  color: headingTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(children: [
            const Text(
              'Enter the OTP send to you at',
              style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: Text(
                email.text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      state = 0;
                    });
                    email.clear();
                  },
                  child: const Text(
                    "Change email",
                    style: TextStyle(color: linkTextColor, fontSize: 15),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                child: Pinput(
              length: 6,
              defaultPinTheme: PinTheme(
                width: MediaQuery.of(context).size.width / 8,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
                decoration: BoxDecoration(
                  color: textFieldBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              validator: (s) {
                return null;
              },
            )),
          ]),
          const SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 80),
            width: MediaQuery.of(context).size.width - 80,
            height: 50,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                            SignupPage(signUpEmail: emailController.text)
                    )
                );
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
