import 'package:flutter/material.dart';


class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 236, 14, 14),
      child: Center(
        child: Text(
          "Homepage",
          style: TextStyle(
            fontSize: 35.0,
          ),
        ),
      ),
    );
  }
}