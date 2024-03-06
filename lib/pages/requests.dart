import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:travel_companion/pages/profile.dart';
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
  final String sentBy;
  final String sentByUsername;
  final String phoneNumber;
  final String message;
  final String sentTo;

  Request({
    required this.sentTo,
    required this.sentByUsername,
    required this.message,
    required this.phoneNumber,
    required this.username,
    this.description,
    required this.date,
    required this.status,
    required this.type,
    required this.tripId,
    required this.source,
    required this.destination,
    required this.time,
    required this.modeOfTransport,
    required this.sentBy,
  });
}

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  late String dropdownValue;
  late String userEmail;
  late List<dynamic> requests;
  late Map<String,dynamic> updations;

  void updateRequests() {

    List<dynamic>finalRequests=[];
    for (var i = 0; i < requests.length; i++) {
      if (updations.containsKey(requests[i]['tripId'])) {
        if (updations[requests[i]['tripId']] == -1) {
          requests[i]['status'] = 'Rejected';
          finalRequests.add(requests[i]);
        }
        else if(updations[requests[i]['tripId']].contains('@iitj.ac.in')){
          continue;
        }
        else {
          requests[i]['status'] = 'Accepted';
          requests[i]['phoneNumber'] = updations[requests[i]['tripId']];
          finalRequests.add(requests[i]);
        }
      }
      else{
        finalRequests.add(requests[i]);
      }
    }
    print(finalRequests);
    if (finalRequests != requests){
      FirebaseFirestore.instance.collection('Requests').doc(userEmail).set({
        'requests': finalRequests
      });
    }
  }

  @override
  void initState() {
    userEmail = FirebaseAuth.instance.currentUser!.email ?? "";
    updations = {};
    requests = [];
    dropdownValue = 'All Requests';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      if (snapshot.error.toString().contains('permission')) {
                        return const Center(child: Text('No Requests yet'));
                      }
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.data!.exists) {
                      requests = List.from(snapshot.data!.get('requests'));
                      updations = Map<String, dynamic>.from(snapshot.data!.data() ?? {});
                      print(160);
                      print(requests);
                      updateRequests();
                      print('updated requests - 163');
                    }
                    if (requests.isEmpty) {
                      return const Center(child: Text('No Requests found'));
                    }
                    return ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        Request req = Request(
                          username: "",
                          message: requests[index]['Message'] ?? 'Not available',
                          sentByUsername: requests[index]['sentByUsername'] ?? 'Not available',
                          phoneNumber: requests[index]['phoneNumber'] ?? 'Not available',
                          date: "",
                          type: requests[index]['type'],
                          tripId: requests[index]['tripId'],
                          source: "",
                          destination: "",
                          time: "",
                          modeOfTransport: "",
                          sentBy: requests[index]['sentBy'],
                          status: requests[index]['status'],
                          sentTo: requests[index]['sentTo'],
                        );
                        return FutureBuilder<Request>(
                          future: _getRequestWithData(req),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(width: 0, height: 0);
                            } else if (snapshot.hasError) {
                              if (snapshot.error.toString().contains('does not exist')) {
                                // Automatically remove request if trip data is not found
                                setState(() {
                                  requests.removeAt(index);
                                });
                              }
                              return const SizedBox(width: 0, height: 0);
                            } else if (snapshot.hasData) {
                              if (dropdownValue == 'All Requests' ||
                                  (dropdownValue == 'Sent' && req.type == 'Sent') ||
                                  (dropdownValue == 'Received' && req.type == 'Received')) {
                                return buildRequestTile(snapshot.data!, requests[index], index);
                              } else {
                                return const SizedBox(width: 0, height: 0);
                              }
                            } else {
                              return const SizedBox(height: 0, width: 0);
                            }
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
    try {
      DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance.collection('Trips').doc(request.tripId).get();
      String username = await _getUsername(tripSnapshot['userRef']);
      String source = tripSnapshot['source'];
      String destination = tripSnapshot['destination'];
      String time = tripSnapshot['time'];
      String modeOfTransport = tripSnapshot['modeOfTransport'];
      String phoneNumber = request.phoneNumber;
      return Request(
        username: username,
        message: request.message,
        sentByUsername: request.sentByUsername,
        phoneNumber: request.phoneNumber,
        description: tripSnapshot['desc'],
        date: tripSnapshot['date'],
        status: request.status,
        type: request.type,
        tripId: request.tripId,
        source: source,
        destination: destination,
        time: time,
        modeOfTransport: modeOfTransport,
        sentBy: request.sentBy,
        sentTo: request.sentTo
      );
    } catch (e) {
      print('Error fetching trip data for tripId ${request.tripId}: $e');
      throw e;
    }
  }

  Future<String> _getUsername(DocumentReference userRef) async {
    DocumentSnapshot userSnapshot = await userRef.get();
    return userSnapshot['username'];
  }

  Future<void> _updateRequestStatus(Request request, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('Requests').doc(userEmail).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          List<dynamic> requests = List.from(documentSnapshot['requests']);
          for (int i = 0; i < requests.length; i++) {
            if (requests[i]['tripId'] == request.tripId && requests[i]['sentBy'] == request.sentBy) {
              requests[i]['status'] = newStatus;
              documentSnapshot.reference.update({'requests': requests});
              break;
            }
          }
        }
        else {
          print('Document does not exist');
        }
      });

      if (newStatus == 'Accepted') {
        await FirebaseFirestore.instance.collection('Requests').doc(request.sentBy).update({
          request.tripId: Profile.phoneNumber
        });
        String sentBy = request.sentBy;
        String sentByUsername = request.sentByUsername;
        if (sentBy.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('Trips')
              .doc(request.tripId)
              .update({'companion': FieldValue.arrayUnion(['$sentByUsername $sentBy'])});
        }
      } else {
        await FirebaseFirestore.instance.collection('Requests').doc(request.sentBy).update({
          request.tripId: -1
        });
      }
    } catch (e) {
      print('Error updating request status: $e');
    }
    setState(() {});
  }

  Widget buildRequestTile(Request request, dynamic reqObj, int index) {
    return RequestTile(
      request: request,
      onAccept: () {
        print('accepting');
        _updateRequestStatus(request, 'Accepted');
      },
      onReject: () {
        print('rejected');
        _updateRequestStatus(request, 'Rejected');
      },
      onDelete: () {
        print('withdrawing');
        FirebaseFirestore.instance.collection('Requests').doc(request.sentTo).update({
          request.tripId: request.sentBy
        });
        _removeRequest(request);
      },
    );
  }

  void _removeRequest(request) {
    requests.remove(request);
    FirebaseFirestore.instance.collection('Requests').doc(userEmail).update({'requests': requests});
    setState(() {});
  }
}
