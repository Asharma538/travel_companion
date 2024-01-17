import 'dart:convert';
import 'package:flutter/material.dart';

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
      home: const requests(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class requests extends StatefulWidget {
  const requests({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<requests> {
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
                        onPressed: () {
                          print('Accepted');
                        },
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
                        onPressed: () {
                          print('rejected');
                        },
                        icon: const Icon(Icons.clear, color: Colors.white),
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.red),
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
                onPressed: () {
                  setState(() {
                    // Toggle the isExpanded flag
                    isExpanded = !isExpanded;
                  });
                },
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
