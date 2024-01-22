import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final String userName;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String modeOfTransport;
  final Function() onPressed;

  PostTile({
    required this.userName,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
    required this.modeOfTransport,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(
          userName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: $source\nTo: $destination'),
            Text('Date: $date\nTime: $time\nMode: $modeOfTransport'),
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
