import 'package:flutter/material.dart';

class AppBarWithBack extends StatelessWidget {
  const AppBarWithBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          'Travel Companion App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        CircleAvatar(
          backgroundImage: const AssetImage('lib/assets/images/logo.png'),
          radius: MediaQuery.of(context).size.height / 25,
        ),
      ],
    );
  }
}
