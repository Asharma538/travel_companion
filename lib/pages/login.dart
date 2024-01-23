import 'package:flutter/material.dart';
import '../pages/signup.dart';
import '../pages/home.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 248, 239),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _appBar(context),
                _header(context),
                _inputField(context, emailController, passwordController),
                _forgotPassword(context),
                _signup(context),
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
          radius: MediaQuery.of(context).size.height / 20,
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

  _header(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Login",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            "Enter your credential to Enter",
            style:
                TextStyle(fontSize: 15, color: Color.fromRGBO(97, 97, 97, 1)),
          ),
        ],
      ),
    );
  }

  _inputField(
      context, TextEditingController email, TextEditingController password) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: TextField(
            controller: email,
            decoration: InputDecoration(
                hintText: "Username/Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none),
                fillColor: Colors.amber.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person)),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: TextField(
            controller: password,
            decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.amber.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.password),
            ),
            obscureText: true,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
          child: ElevatedButton(
            onPressed: () async {
              try {
                final credential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email.text, password: password.text)
                    .then((_) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.amberAccent,
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(97, 97, 97, 1),
              ),
            ),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.amber),
      ),
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have an account? "),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SignupPage()));
            },
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.amber),
            ))
      ],
    );
  }
}
