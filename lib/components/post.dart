import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:travel_companion/utils/colors.dart';

class PostTile extends StatelessWidget {
  final String tripId;
  final String userName;
  final String userImage;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String modeOfTransport;
  final Function() onPressed;

  const PostTile({
    super.key,
    required this.tripId,
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
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 12, 10, 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: cardBackgroundColor,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 4),
                  color: Color(0xFFC5C5C5),
                  spreadRadius: 2,
                  blurRadius: 4)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 5),
              child: Row(
                children: [
                  if (userImage != '') ...[
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: ProfilePicture(
                        name: userName,
                        fontsize: 20,
                        radius: 17,
                      ),
                    ),
                  ],
                  const SizedBox(width: 12.0),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
              child: Row(
                children: [
                  _buildElevatedBox(source),
                  const Icon(Icons.arrow_forward, color: Colors.black),
                  _buildElevatedBox(destination),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${date==""? 'Not Decided' : date}',
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Time: ${time==""? 'Not Decided' : time}',
                    style: const TextStyle(
                        fontSize: 13.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Mode: $modeOfTransport',
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w500),
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
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
          color: complementaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
