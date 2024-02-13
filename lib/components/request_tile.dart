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

    return request.status == 'Rejected'
        ? SizedBox.shrink() // Don't show the request if it's rejected
        : Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: screenWidth * 0.03),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                request.username,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${request.source} ',
                          style: TextStyle(fontSize: screenWidth * 0.035)),
                      Icon(Icons.arrow_forward, color: Colors.black, size: screenWidth * 0.04),
                      Text(' ${request.destination}',
                          style: TextStyle(fontSize: screenWidth * 0.035)),
                    ],
                  ),
                  SizedBox(height: 4),
                  if (request.status == 'Pending') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onAccept,
                            icon: Icon(Icons.check, color: Colors.white),
                            label: Text('Accept'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onReject,
                            icon: Icon(Icons.clear, color: Colors.white),
                            label: Text('Reject'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (request.status == 'Accepted') ...[
                    Text(
                      'Phone Number: ${request.phoneNumber}',
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                  ],
                  SizedBox(height: 4),
                  if (isExpanded) ...[
                    Row(
                      children: [
                        Text(
                          'Date: ${request.date.toString()} ',
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                        Spacer(), // Spacer to occupy the space
                        Text(
                          'Time: ${request.time}',
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Mode of Transport: ${request.modeOfTransport}',
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isExpanded
                          ? 'Description: ${request.description!}'
                          : 'Description: ${request.description!.substring(0, 10)}...',
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: onToggleExpansion,
                          child: Text(
                            'Show Less',
                            style: TextStyle(color: Colors.blue, fontSize: screenWidth * 0.03),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    SizedBox(height: 2), // Reduced the height of the show more button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: onToggleExpansion,
                          child: Text(
                            'Show More',
                            style: TextStyle(color: Colors.blue, fontSize: screenWidth * 0.03),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
      ),
    );
  }
}

