import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final String userName;
  final String userImage;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String modeOfTransport;
  final Function() onPressed;

  const PostTile({super.key,
    required this.userName,
    required this.userImage,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
    required this.modeOfTransport,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (userImage!='') ...[
                  SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(userImage),
                    ),
                  ),
                  ] else ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlue,
                        ),
                        width: 40.0,
                        height: 40.0,
                      ),
                  ],
                  const SizedBox(width: 12.0),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildElevatedBox(source),
                  const Icon(Icons.arrow_forward, color: Colors.black),
                  _buildElevatedBox(destination),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: $date',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Time: $time',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Mode: $modeOfTransport',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedBox(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
