import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_companion/utils/colors.dart';
import '../components/post.dart';
import 'package:travel_companion/pages/view_post.dart';
import '../main.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  static List<Map<String, dynamic>> posts = [];

  static Future<List<Map<String, dynamic>>> fetchPosts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Trips').get();

    List<Map<String, dynamic>> posts = [];

    for (var doc in querySnapshot.docs) {
      var queryDocumentSnapshot = await doc.data()['userRef'].get();
      var userData = queryDocumentSnapshot.data() ?? {};
      var post = doc.data();
      post['id'] = doc.id;
      post['username'] = userData['username'];
      post['about'] = userData['about'];
      post['profilePhotoState'] = userData['profilePhotoState'];
      posts.add(post);
    }

    Homepage.posts = posts;
    return posts;
  }

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Map<String, dynamic>>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = Homepage.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: postsFuture,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
                  tripId: post['id'] ?? 'Not Available',
                  userName: post['username'] ?? 'Not Available',
                  userImage: (post['profilePhotoState'] == 0) ? "" : Base.profilePictures[post['profilePhotoState'] - 1],
                  source: post['source'] ?? 'Not Available',
                  destination: post['destination'] ?? 'Not Available',
                  date: post['date'] ?? 'Not Available',
                  time: post['time'] ?? 'Not Available',
                  modeOfTransport: post['modeOfTransport'] ?? 'Not Available',
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPost(post: post),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        posts.removeWhere((p) => p['id'] == post['id']);
                      });
                    }
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
