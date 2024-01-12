import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 238, 126, 21),
      child: Center(
        child: Text(
          "Search",
          style: TextStyle(
            fontSize: 35.0,
          ),
        ),
      ),
    );
  }
}