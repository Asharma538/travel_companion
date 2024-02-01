import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:travel_companiion/pages/authentication/login.dart';
import 'package:travel_companiion/pages/authentication/signup.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  var state = 0;
  final emailController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 248, 239),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _appBar(context),
              if (state == 0) ...[
                _body(context, emailController),
                _signup(context),
              ] else ...[
                _fillOTP(context, emailController),
              ]
            ],
          ),
        ),
      ),
    );
  }

  _appBar(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: const AssetImage('lib/assets/images/logo.png'),
          radius: MediaQuery.of(context).size.height / 25,
        ),
        const Text(
          'Travel Companion App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  _body(context, TextEditingController email) {
    return Container(
      height: MediaQuery.of(context).size.height / 10 * 7.5,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Email Verification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(children: [
            Container(
                alignment: Alignment.centerLeft,
                child: const Text('Enter your email')),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorText: _validate ? "This field is required" : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                  fillColor: Colors.amber.withOpacity(0.1),
                  filled: true,
                ),
              ),
            ),
          ]),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height / 12,
            child: ElevatedButton(
              onPressed: () {
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
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.amberAccent,
              ),
              child: const Text(
                'Send OTP',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(97, 97, 97, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.amber),
            ))
      ],
    );
  }

  _fillOTP(BuildContext context, TextEditingController email) {
    return Container(
      height: MediaQuery.of(context).size.height / 10 * 7.5,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Email Verification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(children: [
            const Text('Enter the OTP send to you at'),
            Text(
              email.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
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
                      style: TextStyle(color: Colors.amber),
                    ))),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width / 8,
                    height: MediaQuery.of(context).size.height / 10,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent[100],
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  validator: (s) {
                    return null;
                  },
                )),
          ]),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height / 12,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignupPage()));
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.amberAccent,
              ),
              child: const Text(
                ' Next',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(97, 97, 97, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}