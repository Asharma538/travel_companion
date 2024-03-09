import 'package:flutter/material.dart';
import 'package:travel_companion/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart'; 

class about_us extends StatelessWidget {

  void _launchURL() async {
    const url = 'https://forms.gle/JXBwR9KiEk83VwpD6';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'About Us',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: secondaryTextColor),
        ),
      ),
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Developed by:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8), 
            Text('Anadi Sharma (Mentor)',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Lakshya Jain',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Divya Kumar',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Radhika Agarwal',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('Arun Kumar',style: TextStyle(fontWeight: FontWeight.bold),),
            Text('For any bugs please Contact Devlup Labs',style: TextStyle(fontWeight: FontWeight.bold),),
            TextButton(  
              onPressed: _launchURL,
              child: Text('Contact Form'),
            ),
          ],
        ),
      ),
    );
  }
}
