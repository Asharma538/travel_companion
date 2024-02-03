import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companiion/pages/home.dart';
import 'package:travel_companiion/pages/view_post.dart';
import '../components/post.dart';
import '../main.dart';

class AboutTextField extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;
  final String userEmail;

  const AboutTextField({
    super.key,
    required this.initialText,
    required this.onSave,
    required this.userEmail,
  });

  @override
  State<AboutTextField> createState() => _AboutTextFieldState();
}

class _AboutTextFieldState extends State<AboutTextField> {
  late TextEditingController _textEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing
        ? TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Add your bio here!!',
            ),
            onEditingComplete: () {
              setState(() {
                _isEditing = false;
                widget.onSave(_textEditingController.text);
              });
            },
          )
        : InkWell(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: Text(
              _textEditingController.text,
              style: const TextStyle(fontSize: 15),
            ),
          );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  static Map<String, dynamic> userData = {};

  static Future<Map<String, dynamic>> fetchUser(String userEmail) async {
    DocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot =
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userEmail)
            .get();
    var userData = queryDocumentSnapshot.data() ?? {};
    if (queryDocumentSnapshot.exists) {
      userData['id'] = queryDocumentSnapshot.id;
    }
    Profile.userData = userData;

    return userData;
  }

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> userFuture;
  String userEmail = 'sharma.130@iitj.ac.in';
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    userFuture = Profile.fetchUser(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            } else {
              userData = snapshot.data;
              if (userData == null) {
                return const Center(
                  child: Text(
                    'User not found',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          // Navigate to the login or home page after successful logout
                          Navigator.pushReplacementNamed(context,
                              '/login'); // Replace '/login' with your desired route
                        } catch (e) {
                          print('Error logging out: $e');
                        }
                      },
                      icon: const Icon(Icons.logout),
                    ),
                    Stack(
                      children: [
                        Center(
                            child: (userData!['profilePhotoState'] == 0)
                                ? ProfilePicture(
                                    name: userData!['username'],
                                    radius: 100,
                                    fontsize: 60,
                                  )
                                : CircleAvatar(
                                    radius: 100.0,
                                    backgroundImage: NetworkImage(
                                        Base.profilePictures[
                                            userData!['profilePhotoState']]),
                                  )),
                        Positioned(
                          bottom: 0.0,
                          right: MediaQuery.of(context).size.width * 0.5 - 110,
                          child: FloatingActionButton(
                            shape: const CircleBorder(eccentricity: 0.9),
                            onPressed: () {
                              _openProfilePictureDrawer(context);
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: ListTile(
                        title: Center(
                          child: Text(
                            userData?['username'] ?? '',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: const Text(
                        "About",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      subtitle: AboutTextField(
                        initialText: userData?['about'] ?? '',
                        onSave: (newAbout) {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(userEmail)
                              .update({'about': newAbout});
                        },
                        userEmail: userEmail,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    for (var i = 0; i < Homepage.posts.length; i++) ...[
                      if (Homepage.posts[i]['username'] ==
                          userData?['username']) ...[
                        PostTile(
                            tripId: Homepage.posts[i]['id'],
                            userName: Homepage.posts[i]['username'],
                            userImage: Homepage.posts[i]['userImage'],
                            source: Homepage.posts[i]['source'],
                            destination: Homepage.posts[i]['destination'],
                            date: Homepage.posts[i]['date'],
                            time: Homepage.posts[i]['time'],
                            modeOfTransport: Homepage.posts[i]
                                ['modeOfTransport'],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPost(
                                    post: Homepage.posts[i],
                                  ),
                                ),
                              );
                            })
                      ]
                    ]
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _openProfilePictureDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Select Profile Picture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (BuildContext context, int index) {
                    // Replace the below placeholder image with your actual images
                    return GestureDetector(
                      onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userData?['id'])
                            .update({'profilePhotoState': index});

                        setState(() {
                          userData?['profilePhotoState'] = index;
                        });

                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.all(8),
                          child: (index == 0)
                              ? ProfilePicture(
                                  name: userData!['username'],
                                  radius: 8,
                                  fontsize: 30,
                                )
                              : CircleAvatar(
                                  radius: 8.0,
                                  backgroundImage: NetworkImage(
                                      Base.profilePictures[index - 1]),
                                )),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
