import 'package:flutter/material.dart';

class Profile extends StatelessWidget { 
const Profile({Key? key}) : super(key: key); 

@override 
Widget build(BuildContext context) { 
	return Container( 
	color: Color.fromARGB(255, 10, 117, 160), 
	child: Center(
		child: Text(
      "Profile",
      style: TextStyle(
        fontSize: 35.0,
      ),
    ), 
	), 
	); 
} 
} 
