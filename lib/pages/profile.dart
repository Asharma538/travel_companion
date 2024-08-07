import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_companion/pages/authentication/signin.dart';
import 'package:travel_companion/pages/home.dart';
import 'package:travel_companion/pages/view_post.dart';
import 'package:travel_companion/utils/colors.dart';
import '../components/post.dart';
import '../main.dart';
import '../pages/about_us.dart';

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
              hintText: 'Here it goes...',
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
  static String phoneNumber = "";

  static Future<Map<String, dynamic>> fetchUser(
  DocumentReference userRef) async {
      DocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot = await userRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      var userData = queryDocumentSnapshot.data() ?? {};
      if (queryDocumentSnapshot.exists) {
        userData['id'] = queryDocumentSnapshot.id;
      }
      Profile.userData = userData;
      var phoneNumberDocument = await FirebaseFirestore.instance.collection('PhoneNumbers').doc(userData['id']).get();
      Profile.phoneNumber = phoneNumberDocument.data()?['phoneNumber'] ?? 'Add you phone number';
      return userData;
  }

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> userFuture;
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  Map<String, dynamic>? userData;
  dynamic phoneNumber;

  @override
  void initState() {
    DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(userEmail);
    userFuture = Profile.fetchUser(userRef);
    super.initState();
  }

  showNormalSnackBar(BuildContext context,String snackBarText) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            dismissDirection: DismissDirection.horizontal,
            margin: const EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            content: Text(snackBarText)
        )
    );
  }
  showErrorSnackBar(BuildContext context,String snackBarText){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            dismissDirection: DismissDirection.horizontal,
            margin: const EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            backgroundColor: errorRed,
            content: Text(snackBarText)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () {
                        try {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        } catch (e) {
                          showErrorSnackBar(context,'Error logging out: ${e.toString()}');
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
                                    backgroundImage: NetworkImage(Base
                                            .profilePictures[
                                        userData!['profilePhotoState'] - 1]),
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
                            style: const TextStyle(fontSize: 30,overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "Phone Number",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: AboutTextField(
                        initialText: Profile.phoneNumber ?? '',
                        onSave: (newPhoneNumber) {
                          if (newPhoneNumber.length!=13 || newPhoneNumber[0]!='+'){
                            showErrorSnackBar(context, "Give a 10 digit number after country code");
                            return;
                          }
                          FirebaseFirestore.instance
                            .collection('PhoneNumbers')
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .set({'phoneNumber': newPhoneNumber});
                        },
                        userEmail: userEmail!,
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        "About",
                        style: TextStyle(
                          fontSize: 16,
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
                        userEmail: userEmail!,
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
                            userImage: (Homepage.posts[i]
                                        ['profilePhotoState'] ==
                                    0)
                                ? ""
                                : Base.profilePictures[
                                    Homepage.posts[i]['profilePhotoState'] - 1],
                            source:
                                Homepage.posts[i]['source'] ?? 'Not Decided',
                            destination: Homepage.posts[i]['destination'] ??
                                'Not Decided',
                            date: Homepage.posts[i]['date'] ?? 'Not Decided',
                            time: Homepage.posts[i]['time'] ?? 'Not Decided',
                            modeOfTransport: Homepage.posts[i]
                                    ['modeOfTransport'] ??
                                'Not Decided',
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
                    ],
    
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => about_us()),
                          );
                        },
                        child: Text('About Us',style: TextStyle(color: linkTextColor),),
                        ),
                    )
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
                            .collection('Users')
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
                                  fontsize: 20,
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
