import 'package:flutter/material.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  var state = 0;
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 248, 239),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(24),
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _appbar(context),
                  _header(context),
                  _input(context, emailController),
                  _login(context),
                ]),
          ),
        ),
      ),
    );
  }

  _appbar(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: const AssetImage('lib/assets/images/logo.png'),
          radius: MediaQuery.of(context).size.height / 20,
        ),
        const Text(
          'Travel Conpanion App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  _header(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Email Verification',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            'Enter email to be verified',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(97, 97, 97, 1),
            ),
          ),
        ],
      ),
    );
  }

  _input(context, TextEditingController emailController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.amber.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 12,
          child: ElevatedButton(
            onPressed: () {},
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
        )
      ],
    );
  }

  _login(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account ?',
        ),
        TextButton(
            onPressed: () {},
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.amber),
            ))
      ],
    );
  }
}
