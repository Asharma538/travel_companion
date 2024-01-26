import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import '../components/post.dart';

class ProfileData {
  String username;
  String? imageUrl;
  String? about;
  String email;

  ProfileData({
    required this.username,
    this.imageUrl,
    this.about,
    required this.email,
  });
}

class AboutTextField extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;

  const AboutTextField({super.key, required this.initialText, required this.onSave});

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
              widget.initialText,
              style: const TextStyle(fontSize: 15),
            ),
          );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<ProfileData> loadData(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString('lib/data/profile_data.json');

      dynamic jsonData = jsonDecode(data)['profile'];

      ProfileData profileData = ProfileData(
          username: jsonData['username'],
          email: jsonData['email'],
          imageUrl: jsonData['imageUrl'],
          about: jsonData['about']);
      return profileData;
    } catch (e) {
      // print(e);
      return ProfileData(username: "", email: "", imageUrl: "", about: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: loadData(context),
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
                  ProfileData profileData = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.logout)),
                        Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage:
                                      NetworkImage(profileData.imageUrl ?? "")),
                            ),
                            Positioned(
                                bottom: 0.0,
                                right: MediaQuery.of(context).size.width*0.5 - 110,
                                child: FloatingActionButton(
                                  shape: const CircleBorder(eccentricity: 0.9),
                                  onPressed: () {},
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
                                profileData.username,
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
                            initialText: profileData.about ?? "",
                            onSave: (newAbout) {
                              // Handle saving the new about information
                              // print('New About: $newAbout');
                              // Assuming you want to update the UI with the new about information
                              setState(() {
                                profileData.about = newAbout;
                              });
                            },
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        PostTile(
                          userName: 'userName',
                          userImage: '',
                          source: 'source',
                          destination: 'destination',
                          date: 'date',
                          time: 'time',
                          modeOfTransport: 'modeOfTransport',
                          onPressed: () {
                            },
                        ),
                        PostTile(
                          userName: 'userName',
                          userImage: '',
                          source: 'source',
                          destination: 'destination',
                          date: 'date',
                          time: 'time',
                          modeOfTransport: 'modeOfTransport',
                          onPressed: () {
                          },
                        ),
                        PostTile(
                          userName: 'userName',
                          userImage: '',
                          source: 'source',
                          destination: 'destination',
                          date: 'date',
                          time: 'time',
                          modeOfTransport: 'modeOfTransport',
                          onPressed: () {
                          },
                        )
                      ],
                    ),
                  );
                }
              }),
        ));
  }
}
