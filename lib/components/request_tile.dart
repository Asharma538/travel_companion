import 'package:flutter/material.dart';
import '../pages/requests.dart';

class RequestTile extends StatelessWidget {
  final Request request;
  final bool isExpanded;
  final Function() onAccept;
  final Function() onReject;
  final Function() onToggleExpansion;

  RequestTile({
    required this.request,
    required this.isExpanded,
    required this.onAccept,
    required this.onReject,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    request.username,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (request.status != 'sent')
                  Row(
                    children: [
                      IconButton(
                        onPressed: onAccept,
                        icon: const Icon(Icons.check, color: Colors.white),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.green),
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(screenWidth * 0.02),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      IconButton(
                        onPressed: onReject,
                        icon: const Icon(Icons.clear, color: Colors.white),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all(CircleBorder()),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(screenWidth * 0.02),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (request.status != 'sent')
                  Text('From: ${request.source}',
                      style: TextStyle(fontSize: screenWidth * 0.06)),
                if (request.status != 'sent')
                  Text('To: ${request.destination}',
                      style: TextStyle(fontSize: screenWidth * 0.06)),
                Text('Date: ${request.date.toString()}',
                    style: TextStyle(fontSize: screenWidth * 0.06)),
                if (request.status != 'sent')
                  Text('Time: ${request.time}',
                      style: TextStyle(fontSize: screenWidth * 0.06)),
                if (request.description != null)
                  Text(
                    isExpanded
                        ? 'Description: ${request.description!}'
                        : 'Description: ${request.description!.substring(0, request.description!.length ~/ 2)}...',
                    style: TextStyle(fontSize: screenWidth * 0.06),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onToggleExpansion,
                child: Text(
                  isExpanded ? 'Show Less' : 'Show More',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
