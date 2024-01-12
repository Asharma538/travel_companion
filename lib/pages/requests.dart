import 'package:flutter/material.dart';


class Requests extends StatelessWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 216, 78, 181),
      child: Center(
          child: Text(
        "Requests",
        style: TextStyle(
          fontSize: 35.0,
        ),
      )),
    );
  }
}