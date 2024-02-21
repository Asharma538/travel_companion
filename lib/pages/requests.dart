import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_companion/pages/profile.dart';
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

  Request({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
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
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: ['All Requests', 'Sent', 'Received'].map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  dropdownColor: Colors.lightBlue,
                ),
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Requests')
                      .doc(userEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    List<dynamic> requests = [];
                    if (snapshot.data!.exists) {
                      requests = snapshot.data?.get('requests');
                    }
                    oldRequests = requests;

                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        Request req = Request(
                            username: "",
                            date: "",
                            type: requests[index]['type'],
                            tripId: requests[index]['tripId'],
                            source: "",
                            destination: "",
                            time: "",
                            modeOfTransport: "",
                            phoneNumber: "",
                            sentBy: requests[index]['sentBy'],
                            status: requests[index]['status']);
                        return FutureBuilder<Request>(
                          future: _getRequestWithData(req),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(width: 0, height: 0);
                            } else if (snapshot.hasError) {
                              if (snapshot.error
                                  .toString()
                                  .contains('does not exist')) {
                                print('request for trip with tripId ' +
                                    req.tripId +
                                    ' expired');
                              }
                              return const SizedBox(width: 0, height: 0);
                            }

                            newRequests.add(oldRequests[index]);
                            if (dropdownValue == 'All Requests') return buildRequestTile(snapshot.data!, oldRequests[index]);
                            else if (dropdownValue == 'Sent' && oldRequests[index]['type'] == 'Sent') return buildRequestTile(snapshot.data!, oldRequests[index]);
                            else if (dropdownValue == 'Received' && oldRequests[index]['type'] == 'Received') return buildRequestTile(snapshot.data!, oldRequests[index]);
                            else return SizedBox(width: 0,height: 0,);
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
    DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
        .collection('Trips')
        .doc(request.tripId)
        .get();

    String username = await _getUsername(tripSnapshot['userRef']);
    String source = tripSnapshot['source'];
    String destination = tripSnapshot['destination'];
    String time = tripSnapshot['time'];
    String modeOfTransport = tripSnapshot['modeOfTransport'];
    String phoneNumber = await _getPhoneNumber(tripSnapshot['userRef']);

    return Request(
      username: username,
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
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(userEmail)
          .collection('requests')
          .doc(request.tripId)
          .update({'status': newStatus});

      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(request.sentBy)
          .collection('requests')
          .doc(request.tripId)
          .update({'status': newStatus});

      if (newStatus == 'Accepted' || newStatus == 'Rejected') {
        String sentBy = request.sentBy;
        if (sentBy.isNotEmpty) {
          DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
              .collection('Trips')
              .doc(request.tripId)
              .get();

          List<dynamic> companionArray = List.from(tripSnapshot['companion']);
          companionArray.add(sentBy);

          await FirebaseFirestore.instance
              .collection('Trips')
              .doc(request.tripId)
              .update({'companion': companionArray});
        }
      }
    } catch (e) {
      print('Error updating request status: $e');
    }
  }

  Widget buildRequestTile(Request request, dynamic reqObj) {
    return RequestTile(
      request: request,
      onAccept: () {
        _updateRequestStatus(request, 'Accepted');
      },
      onReject: () {
        _updateRequestStatus(request, 'Rejected');
      },
      onToggleExpansion: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      onDelete: () {
        _removeRequest(reqObj);
      },
      isExpanded: isExpanded,
    );
  }

  bool isExpanded = false;

  void _removeRequest(request) {
    newRequests.remove(request);
    if (newRequests.length < oldRequests.length)
      FirebaseFirestore.instance
          .collection('Requests')
          .doc(userEmail)
          .update({'requests': newRequests});
  }

  @override
  void dispose() {
    if (oldRequests.length >= newRequests.length) {
      super.dispose();
      return;
    } else {
      FirebaseFirestore.instance
          .collection('Requests')
          .doc(userEmail)
          .update({'requests': newRequests});
    }
    super.dispose();
  }
}
