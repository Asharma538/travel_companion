import 'package:flutter/material.dart';
import '../pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userNameController = TextEditingController();
    // var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 248, 239),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _appBar(context),
                _body(context, userNameController, emailController,
                    passwordController, confirmPasswordController),
              ],
            ),
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

  _body(context, TextEditingController username, TextEditingController email,
      TextEditingController password, TextEditingController confirm_password) {
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
                "SIGN UP",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Column(children: [
              // Container(alignment: Alignment.centerLeft, child: Text('Email')),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.amber.withOpacity(0.1),
                    filled: true,
                    // prefixIcon: const Icon(Icons.person)
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.amber.withOpacity(0.1),
                    filled: true,
                    // prefixIcon: const Icon(Icons.person)
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.amber.withOpacity(0.1),
                    filled: true,
                    // prefixIcon: const Icon(Icons.person)
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
                child: TextField(
                  controller: confirm_password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: Colors.amber.withOpacity(0.1),
                    filled: true,
                    // prefixIcon: const Icon(Icons.person)
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height / 12,
            child: ElevatedButton(
              onPressed: () async {
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email.text, password: password.text)
                    .then((_) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                }).catchError((e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.amberAccent,
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromRGBO(97, 97, 97, 1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
