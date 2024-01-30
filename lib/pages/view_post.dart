import 'package:flutter/material.dart';

class ViewPost extends StatefulWidget {
  final Map<String, dynamic> post;

  const ViewPost({Key? key, required this.post}) : super(key: key);

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  late Map<String, dynamic> post;
  String loggedInUser = '';

  @override
  void initState() {
    super.initState();
    post = widget.post;
  }

  bool isOwnPost() {
    return post.isNotEmpty && post['username'] == loggedInUser;
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff302360),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "View Post",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 225, 224, 227),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${post['username']}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Text(
              "About: ${post['about']}",
              style: const TextStyle(
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
              "From: ${post['source']}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Text(
              "To: ${post['destination']}",
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
                  "Date: ${post['date']}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Time: ${post['time']}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            Text(
              "Mode Of Transportation: ${post['modeOfTransport']}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.height * 0.05),
            if (post['desc']!=null) ...[
              Text(
                "Description: ${post['desc']}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
            else ...[
              const Text(
                "Description: Not Specified",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
                ] else ...[
                  ElevatedButton(
                    onPressed: () {
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
                  const SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
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
