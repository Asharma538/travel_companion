import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewPost(),
    );
  }
}

class Request {
  final String username;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String description;

  Request({
    required this.username,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
    this.description = "",
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      username: json['username'],
      source: json['source'],
      destination: json['destination'],
      date: json['date'],
      time: json['time'],
      description: json['description'] ?? "",
    );
  }
}

List<Request> parseRequests(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr)['requests'];
  return jsonList.map((json) => Request.fromJson(json)).toList();
}

class ViewPost extends StatefulWidget {
  const ViewPost({Key? key});

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  List<Request> requests = [];

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final String data = await rootBundle.loadString('lib/data/requests.json');
    setState(() {
      requests = parseRequests(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    print(requests);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 224, 227),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  requests.isNotEmpty ? "Name: ${requests[0].username}" : "",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Text(
                "About:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Divider(
                height: 20,
                color: Colors.black,
                thickness: 2,
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Text(
                requests.isNotEmpty ? "From: ${requests[0].source}" : "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Text(
                requests.isNotEmpty ? "To: ${requests[0].destination}" : "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    requests.isNotEmpty ? "Date: ${requests[0].date}" : "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    requests.isNotEmpty ? "Time: ${requests[0].time}" : "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Text(
                "Mode Of Transportation:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.05),
              Text(
                requests.isNotEmpty
                    ? "Description: ${requests[0].description}"
                    : "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.1),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "REQUEST",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff302360),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
