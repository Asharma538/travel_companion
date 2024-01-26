import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Post {
  final String username;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String description;

  Post({
    required this.username,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
    this.description = "",
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'],
      source: json['source'],
      destination: json['destination'],
      date: json['date'],
      time: json['time'],
      description: json['description'] ?? "",
    );
  }
}

List<Post> parsePosts(String jsonStr) {
  final List<dynamic> jsonList = json.decode(jsonStr)['requests'];
  return jsonList.map((json) => Post.fromJson(json)).toList();
}

class ViewPost extends StatefulWidget {
  const ViewPost({super.key});

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  List<Post> requests = [];
  String loggedInUser = 'Ash538';

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final String data = await rootBundle.loadString('lib/data/requests.json');
    setState(() {
      requests = parsePosts(data);
    });
  }

  bool isOwnPost(){
    return requests.isNotEmpty && requests[0].username == loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    print(requests);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 224, 227),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              requests.isNotEmpty ? "Name: ${requests[0].username}" : "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            const Text(
              "About:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            const Divider(
              height: 20,
              color: Colors.black,
              thickness: 2,
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Text(
              requests.isNotEmpty ? "From: ${requests[0].source}" : "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Text(
              requests.isNotEmpty ? "To: ${requests[0].destination}" : "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  requests.isNotEmpty ? "Date: ${requests[0].date}" : "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  requests.isNotEmpty ? "Time: ${requests[0].time}" : "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            const Text(
              "Mode Of Transportation:",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Text(
              requests.isNotEmpty
                  ? "Description: ${requests[0].description}"
                  : "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.1),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isOwnPost()) ...[
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff302360),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "REQUEST",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ]
                  else ...[
                    ElevatedButton(
                        onPressed: (){
                          print('User requested Edit');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff302360),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                    ),
                    const SizedBox(width: 40,),
                    ElevatedButton(
                      onPressed: (){
                        print('User requested Delete');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff302360),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
          ],
        ),
      ),
    );
  }
}
