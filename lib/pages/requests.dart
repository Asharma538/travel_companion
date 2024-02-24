import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_companion/utils/colors.dart';
import '../components/request_tile.dart';

class Request {
  final String username;
  final String? description;
  final String date;
  final String? status;
  final String type;
  final String tripId;
  final String source;
  final String destination;
  final String time;
  final String modeOfTransport;
  final String phoneNumber;
  final String sentBy;
  final String sentByUsername;
  final String sentByPhoneNumber;

  Request({
    required this.sentByUsername,
    required this.sentByPhoneNumber,
    required this.username,
    this.description,
    required this.date,
    this.status,
    required this.type,
    required this.tripId,
    required this.source,
    required this.destination,
    required this.time,
    required this.modeOfTransport,
    required this.phoneNumber,
    required this.sentBy,
  });
}

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  String dropdownValue = 'All Requests';
  String userEmail = FirebaseAuth.instance.currentUser!.email ?? "";
  List<dynamic> oldRequests = [];
  List<dynamic> newRequests = [];
  List<bool> isExpanded = [];

  @override
  void initState() {
    oldRequests = [];
    newRequests = [];
    isExpanded = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    oldRequests = [];
    newRequests = [];
    return Scaffold(
      body: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                      color: complementaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButton(
                      underline: const SizedBox(height: 0,width: 0,),
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down,color: secondaryTextColor,),
                      items: ['All Requests', 'Sent', 'Received'].map((item) {
                        return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(color: secondaryTextColor),
                            )
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      dropdownColor: complementaryColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('Requests').doc(userEmail).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    List<dynamic> requests = [];
                    if (snapshot.data!.exists) {
                      requests = snapshot.data?.get('requests');
                    }
                    oldRequests = requests;
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index){
                      Request req = Request(
                          username: "",
                          sentByUsername: requests[index]['sentByUsername'] ?? 'Not available',
                          sentByPhoneNumber: requests[index]['sentByPhoneNumber'] ?? 'Not available',
                          date: "",type: requests[index]['type'],
                          tripId: requests[index]['tripId'],
                          source: "",destination: "",time: "",
                          modeOfTransport: "",phoneNumber: "",
                          sentBy: requests[index]['sentBy'],status: requests[index]['status']
                      );
                        return FutureBuilder<Request>(
                          future: _getRequestWithData(req),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) { return const SizedBox(width: 0, height: 0); }
                            else if (snapshot.hasError) {
                              if (snapshot.error.toString().contains('does not exist')) {
                                print('request for trip with tripId ${req.tripId} expired');
                              }
                              return const SizedBox(width: 0, height: 0);
                            }
                            else if (snapshot.hasData){
                              newRequests.add(oldRequests[index]);
                              isExpanded.add(false);
                              if (dropdownValue == 'All Requests') {
                                return buildRequestTile(snapshot.data!, oldRequests[index], index);
                              } else if (dropdownValue == 'Sent' && oldRequests[index]['type'] == 'Sent') {
                                return buildRequestTile(snapshot.data!, oldRequests[index], index);
                              }
                              else if (dropdownValue == 'Received' && oldRequests[index]['type'] == 'Received') {
                                return buildRequestTile(snapshot.data!, oldRequests[index], index);
                              }
                              else {
                                return const SizedBox(width: 0,height: 0,);
                              }
                            }
                            else { return const SizedBox(height: 0,width: 0,); }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Request> _getRequestWithData(Request request) async {
    DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance.collection('Trips').doc(request.tripId).get();
    String username = await _getUsername(tripSnapshot['userRef']);
    String source = tripSnapshot['source'];
    String destination = tripSnapshot['destination'];
    String time = tripSnapshot['time'];
    String modeOfTransport = tripSnapshot['modeOfTransport'];
    String phoneNumber = await _getPhoneNumber(tripSnapshot['userRef']);
    return Request(
      username: username,
      sentByUsername: request.sentByUsername,
      sentByPhoneNumber: request.sentByPhoneNumber,
      description: tripSnapshot['desc'],
      date: tripSnapshot['date'],
      status: request.status,
      type: request.type,
      tripId: request.tripId,
      source: source,
      destination: destination,
      time: time,
      modeOfTransport: modeOfTransport,
      phoneNumber: phoneNumber,
      sentBy: request.sentBy,
    );
  }

  Future<String> _getUsername(DocumentReference userRef) async {
    DocumentSnapshot userSnapshot = await userRef.get();
    return userSnapshot['username'];
  }

  Future<String> _getPhoneNumber(DocumentReference userRef) async {
    DocumentSnapshot userSnapshot = await userRef.get();
    return userSnapshot['phoneNumber'];
  }

  Future<void> _updateRequestStatus(Request request, String newStatus) async {
    try {
      print('Updating request status to $newStatus');
      print('Request tripId: ${request.tripId}, sentBy: ${request.sentBy}, userEmail: ${userEmail}');
      await FirebaseFirestore.instance.collection('Requests').doc(userEmail).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          List<dynamic> requests = documentSnapshot['requests'];

          for (int i = 0; i < requests.length; i++) {
            if (requests[i]['tripId'] == request.tripId) {
              requests[i]['status'] = newStatus;

              documentSnapshot.reference.update({'requests': requests});
              break;
            }
          }
        } else {
          print('Document does not exist');
        }
      });
      await FirebaseFirestore.instance.collection('Requests').doc(request.sentBy).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          List<dynamic> requests = documentSnapshot['requests'];

          for (int i = 0; i < requests.length; i++) {
            if (requests[i]['tripId'] == request.tripId) {
              requests[i]['status'] = newStatus;

              documentSnapshot.reference.update({'requests': requests});
              break;
            }
          }
        } else {
          print('Document does not exist');
        }
      });

      if (newStatus == 'Accepted' || newStatus == 'Rejected') {
        String sentBy = request.sentBy;
        if (sentBy.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Trips')
              .doc(request.tripId)
              .update({'companion': FieldValue.arrayUnion([sentBy])});

        }
      }
    } catch (e) {
      print('Error updating request status: $e');
    }
    setState(() {});
  }

  Widget buildRequestTile(Request request, dynamic reqObj,int index) {
    return RequestTile(
      request: request,
      onAccept: () {
        _updateRequestStatus(request, 'Accepted');
        print("request accepted");
      },
      onReject: () {
        _updateRequestStatus(request, 'Rejected');
      },
      onDelete: () {
        _removeRequest(reqObj);
      },
    );
  }

  void _removeRequest(request) {
    newRequests.remove(request);
    if (newRequests.length < oldRequests.length) {
      FirebaseFirestore.instance.collection('Requests').doc(userEmail).update({'requests': newRequests});

    }
    isExpanded.removeLast();
    setState(() {});
  }

  @override
  void dispose() {
    if (oldRequests.length < newRequests.length) {
      FirebaseFirestore.instance.collection('Requests').doc(userEmail).update({'requests': newRequests});
    }
    super.dispose();
  }
}