import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/request_tile.dart';



class Request {
  final String username;
  final String? description;
  final String date;
  final String? status;
  final String source;
  final String destination;
  final String time;

  Request({
    required this.username,
    this.description,
    required this.date,
    this.status,
    required this.source,
    required this.destination,
    required this.time,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Requests(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  String dropdownValue = 'All Requests';
  List<Request> allRequests = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('lib/data/requests.json');

    Map<String, dynamic> jsonData = jsonDecode(data);

    if (jsonData.containsKey('requests') && jsonData['requests'] is List) {
      List<dynamic> requestsData = jsonData['requests'];

      List<Request> requests = requestsData
          .map((json) => Request(
        username: json['username'] ?? '',
        description: json['description'] ?? 'Not decided',
        date: json['date'],
        status: json['status'] ?? '',
        source: json['source'] ?? '',
        destination: json['destination'] ?? '',
        time: json['time'] ?? '',
      ))
          .toList();

      setState(() {
        allRequests = requests;
      });
    } else {
      print(
          'Invalid JSON structure. Expected a "requests" property of type List.');
    }
  }

  List<Request> getFilteredRequests() {
    if (dropdownValue == 'All Requests') {
      return allRequests;
    } else if (dropdownValue == 'Sent') {
      return allRequests.where((request) => request.status == 'sent').toList();
    } else if (dropdownValue == 'Received') {
      return allRequests
          .where((request) => request.status != 'sent')
          .toList();
    }
    return [];
  }

  Widget buildRequestTile(Request request) {
    return RequestTile(
      request: request,
      isExpanded: isExpanded,
      onAccept: () {
        print('Accepted');
      },
      onReject: () {
        print('Rejected');
      },
      onToggleExpansion: () {
        setState(() {
          // Toggle the isExpanded flag
          isExpanded = !isExpanded;
        });
      },
    );
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<Request> filteredRequests = getFilteredRequests();

    filteredRequests.sort((a, b) => a.date.compareTo(b.date));

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
                  underline: SizedBox(height: 0),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    return buildRequestTile(filteredRequests[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
