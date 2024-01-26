import 'package:flutter/material.dart';
import 'package:travel_companiion/pages/view_post.dart';
import 'dart:convert';
import '../components/post.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<PostData> posts = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String data =
        await DefaultAssetBundle.of(context).loadString('lib/data/posts.json');

    Map<String, dynamic> jsonData = jsonDecode(data);

    List<PostData> loadedPosts = (jsonData['posts'] as List<dynamic>?)
            ?.map((json) => PostData(
                  userName: json['username'],
                  userImage: json['userImage'],
                  source: json['source'],
                  destination: json['destination'],
                  date: json['date'],
                  time: json['time'],
                  modeOfTransport: json['modeOfTransport'],
                ))
            .toList() ??
        [];

    setState(() {
      posts = loadedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostTile(
            userName: posts[index].userName,
            userImage: posts[index].userImage,
            source: posts[index].source,
            destination: posts[index].destination,
            date: posts[index].date,
            time: posts[index].time,
            modeOfTransport: posts[index].modeOfTransport,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => const ViewPost()
                  )
              );
            },
          );
        },
      ),
    );
  }
}

class PostData {
  final String userName;
  final String userImage;
  final String source;
  final String destination;
  final String date;
  final String time;
  final String modeOfTransport;

  PostData({
    required this.userName,
    required this.userImage,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
    required this.modeOfTransport,
  });
}
