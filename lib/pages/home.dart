import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/post.dart';
import 'package:travel_companiion/pages/view_post.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  
  static List<Map<String, dynamic>> posts = [];
  

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Map<String, dynamic>>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = fetchPosts();
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Trips').get();

    List<Map<String, dynamic>> posts = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    Homepage.posts = posts;
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> posts = snapshot.data ?? [];
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostTile(
                  userName: post['username']?? 'Not Available',
                  userImage: post['userImage']?? 'Not Available',
                  source: post['source']?? 'Not Available',
                  destination: post['destination']?? 'Not Available',
                  date: post['date'] ?? 'Not Available',
                  time: post['time']?? 'Not Available',
                  modeOfTransport: post['modeOfTransport']?? 'Not Available',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPost(post: post),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
