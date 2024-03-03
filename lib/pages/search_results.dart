import 'package:flutter/material.dart';
import 'package:travel_companion/pages/home.dart';
import '../components/post.dart';
import 'package:travel_companion/pages/view_post.dart';
import '../main.dart';

class SearchResultsPage extends StatefulWidget {
  final String fromLocation;
  final String toLocation;
  final String modeOfTransport;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const SearchResultsPage({
    Key? key,
    required this.fromLocation,
    required this.toLocation,
    required this.selectedDate,
    required this.selectedTime,
    required this.modeOfTransport,
  }) : super(key: key);

  static List<Map<String, dynamic>> posts = [];

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<Map<String, dynamic>>> postsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Future.value(Homepage.posts),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              String formattedDate = widget.selectedDate != null
                  ? "${widget.selectedDate!.day}-${widget.selectedDate!.month}-${widget.selectedDate!.year}"
                  : "";
              String formattedTime = widget.selectedTime != null
                  ? "${widget.selectedTime!.hour}:${widget.selectedTime!.minute}"
                  : "";

              print(Homepage.posts);

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _appBarBack(context),
                    for (var i = 0; i < Homepage.posts.length; i++) ...[
                      if ((Homepage.posts[i]['source']
                                      .toString()
                                      .toLowerCase().contains(widget.fromLocation.toLowerCase()) ||
                              widget.fromLocation == "") &&
                          (Homepage.posts[i]['destination']
                                      .toString()
                                      .toLowerCase().contains(widget.toLocation.toLowerCase()) ||
                              widget.toLocation == "") &&
                          (Homepage.posts[i]['date']
                                      .toString()
                                      .toLowerCase().contains(formattedDate.toLowerCase()) ||
                              formattedDate == "") &&
                          (Homepage.posts[i]['time']
                                      .toString()
                                      .toLowerCase().contains(formattedTime.toLowerCase()) ||
                              formattedTime == "") &&
                          (Homepage.posts[i]['modeOfTransport']
                                      .toString()
                                      .toLowerCase().contains(widget.modeOfTransport.toLowerCase()) ||
                              widget.modeOfTransport == "Flexible")) ...[
                        PostTile(
                            tripId: Homepage.posts[i]['id'],
                            userName: Homepage.posts[i]['username'],
                            userImage: (Homepage.posts[i]
                                        ['profilePhotoState'] ==
                                    0)
                                ? ""
                                : Base.profilePictures[
                                    Homepage.posts[i]['profilePhotoState'] - 1],
                            source: Homepage.posts[i]['source'],
                            destination: Homepage.posts[i]['destination'],
                            date: Homepage.posts[i]['date'] ?? 'Not Available',
                            time: Homepage.posts[i]['time'] ?? 'Not Available',
                            modeOfTransport: Homepage.posts[i]
                                    ['modeOfTransport'] ??
                                'Not Available',
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

  _appBarBack(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          'Travel Companion App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        CircleAvatar(
          backgroundImage: const AssetImage('lib/assets/images/logo.png'),
          radius: MediaQuery.of(context).size.height / 25,
        ),
      ],
    );
  }
}
