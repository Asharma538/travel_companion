import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Profiledata {
  String username;
  String? imageUrl;
  String? about;
  String email;

  Profiledata({
    required this.username,
    this.imageUrl,
    this.about,
    required this.email,
  });


}

class AboutTextField extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;

  AboutTextField({required this.initialText, required this.onSave});

  @override
  _AboutTextFieldState createState() => _AboutTextFieldState();
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
            decoration: InputDecoration(
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
              style: TextStyle(fontSize: 15),
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
  Future<Profiledata> loadData(BuildContext context) async {
    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString('lib/data/profile_data.json');

      dynamic jsonData = jsonDecode(data)['profile'];

      Profiledata profiledata = Profiledata(
          username: jsonData['username'],
          email: jsonData['email'],
          imageUrl: jsonData['imageUrl'],
          about: jsonData['about']);
      return profiledata;
    } catch (e) {
      print(e);
      return Profiledata(username: "", email: "", imageUrl: "", about: "");
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
                  Profiledata profiledata = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.logout))),
                        Center(
                          child: CircleAvatar(
                              radius: 100.0,
                              backgroundImage:
                                  NetworkImage(profiledata.imageUrl ?? "")),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 75, 0),
                          child: Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: FloatingActionButton(
                              shape: const CircleBorder(eccentricity: 0.9),
                              onPressed: () {},
                              backgroundColor: Colors.white,
                              child: Icon(Icons.edit),
                            ),
                          ),
                        ),
                        Center(
                          child: ListTile(
                            title: Center(
                              child: Text(
                                profiledata.username,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            "About",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          subtitle: AboutTextField(
                            initialText: profiledata.about ?? "",
                            onSave: (newAbout) {
                              // Handle saving the new about information
                              print('New About: $newAbout');

                              // Assuming you want to update the UI with the new about information
                              setState(() {
                                profiledata.about = newAbout;
                                    // profiledata.copyWith(about: newAbout);
                              });
                            },
                          ),
                        ),
                        //trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.edit))),
                        //itemprofile("About", profiledata.about ?? "", Icons.info),
                        const Divider(
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(170, 70, 170, 70),
                            color: Colors.grey,
                            child: const Text('Post'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(170, 70, 170, 70),
                            color: Colors.grey,
                            child: const Text('Post'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(170, 70, 170, 70),
                            color: Colors.grey,
                            child: const Text('Post'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
        ));
  }
}

itemprofile(String title, String subtitle, IconData iconData) {
  return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 15),
      ),
      leading: Icon(iconData),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)));
}
