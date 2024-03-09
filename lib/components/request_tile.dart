import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/pages/profile.dart';
import 'package:travel_companion/utils/colors.dart';
import '../pages/requests.dart';

class RequestTile extends StatefulWidget {
  final Request request;
  final Function()? onAccept;
  final Function()? onReject;
  final Function()? onDelete;

  const RequestTile({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onDelete,
  });

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return widget.request.status == 'Rejected'
    ? const SizedBox.shrink() // Don't show the request if it's rejected
    : Card(
        margin: EdgeInsets.symmetric(
            vertical: 4, horizontal: screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(
                Profile.userData['username'] != widget.request.username ? widget.request.username : widget.request.sentByUsername,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${widget.request.source} ',
                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward,
                          color: Colors.black, size: screenWidth * 0.04),
                      Text(' ${widget.request.destination}',
                          style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (widget.request.status == 'Pending') ...[
                    if (widget.request.type == 'Received') ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: widget.onAccept,
                              icon: const Icon(Icons.check, color: secondaryTextColor),
                              label: const Text('Accept',style: TextStyle(color: secondaryTextColor),),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )
                                ),
                                backgroundColor: MaterialStateProperty.all(Colors.green),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: widget.onReject,
                              icon: const Icon(Icons.clear, color: secondaryTextColor),
                              label: const Text('Reject',style: TextStyle(color: secondaryTextColor),),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    )
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                    else ...[
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                  'Are you sure you want to delete this request?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.onDelete!();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(complementaryColor),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            )
                          )
                        ),
                        child: const Text('Withdraw',style: TextStyle(color: secondaryTextColor),)
                      )
                    ]
                  ]
                  else if (widget.request.status == 'Accepted') ...[
                    Text(
                      widget.request.phoneNumber,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                  const SizedBox(height: 4),
                  if (isExpanded) ...[
                    Row(
                      children: [
                        Text(
                          'Date: ${widget.request.date.toString()} ',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(), // Spacer to occupy the space
                        Text(
                          'Time: ${widget.request.time}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mode of Transport: ${widget.request.modeOfTransport}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isExpanded
                          ? 'Description: ${widget.request.description!}'
                          : 'Description: ${widget.request.description!.substring(0, 10)}...',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isExpanded
                          ? 'Message: ${widget.request.message}'
                          : 'Message: ${widget.request.message.substring(0, 10)}...',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            'Show Less',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: screenWidth * 0.03),
                          ),
                        ),
                      ],
                    ),
                  ]
                  else ...[
                    const SizedBox(height:2), // Reduced the height of the show more button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            'Show More',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: screenWidth * 0.03),
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
