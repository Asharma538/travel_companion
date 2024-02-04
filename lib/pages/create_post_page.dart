import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_companion/pages/home.dart';
import 'package:travel_companion/utils/colors.dart';
import '../pages/profile.dart';
import '../main.dart';

class Trip {
  final String about;
  final String createdBy;
  final String date;
  final String desc;
  final String destination;
  final String modeOfTransport;
  final String source;
  final String time;
  final String userImage;
  final String username;

  Trip({
    required this.about,
    required this.createdBy,
    required this.date,
    required this.desc,
    required this.destination,
    required this.modeOfTransport,
    required this.source,
    required this.time,
    required this.userImage,
    required this.username,
  });
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String fromLocation = '';
  String toLocation = '';
  String transportationMode = '';
  String description = '';

  void _showDatePicker(
      BuildContext context, Function(DateTime) onDateSelected) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2034),
    ).then((pickedDate) {
      if (pickedDate != null) {
        onDateSelected(pickedDate);
      }
    });
  }

  void _showTimePicker(BuildContext context, TimeOfDay? selectedTime,
      Function(TimeOfDay) onTimeSelected) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      onTimeSelected(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: secondaryTextColor,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: const Text(
            "New Post",
            style: TextStyle(fontWeight: FontWeight.bold,color: secondaryTextColor),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("FROM", "Ex: Jodhpur", (value) {
              fromLocation = value;
            }),
            const SizedBox(height: 15),
            _buildTextField("TO", "Ex: Airport", (value) {
              toLocation = value;
            }),
            const SizedBox(height: 20),
            _buildDateTimeRow(),
            const SizedBox(height: 20),
            _buildTextField(
                "MODE OF TRANSPORTATION", "Ex: Flight/Train/Taxi/Auto etc.",
                (value) {
              transportationMode = value;
            }),
            const SizedBox(height: 15),
            _buildTextField(
                "DESCRIPTION", "Ex: Flight name or no./Train name or no.",
                (value) {
              description = value;
              print(description);
            }, maxLines: 2),
            const Expanded(child: SizedBox()),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await createNewTrip(context);
                  } catch (e) {
                    print("Error creating post 1: $e");
                    // Handle the error as needed
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  backgroundColor: complementaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Create Post",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged,{int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.black,
          ),
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: textFieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              color: placeholderTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDateTimeButton("DATE", Icons.calendar_today, () {
          _showDatePicker(context, (date) {
            setState(() {
              selectedDate = date;
            });
          });
        }),
        SizedBox(width: MediaQuery.of(context).size.width*0.1 - 16,),
        _buildDateTimeButton("TIME", Icons.access_time, () {
          _showTimePicker(context, selectedTime, (time) {
            setState(() {
              selectedTime = time;
            });
          });
        }),
      ],
    );
  }

  Widget _buildDateTimeButton(String label, IconData icon, VoidCallback onPressed) {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.06,
      onPressed: onPressed,
      color: secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide.none,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            selectedDate != null && label == "DATE"
                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                : selectedTime != null && label == "TIME"
                    ? "${selectedTime!.hour}:${selectedTime!.minute}"
                    : label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createNewTrip(BuildContext context) async {
    if (fromLocation.isEmpty || toLocation.isEmpty) {
      print("Please fill all the fields");
      return;
    }
    String formattedDate = selectedDate!=null? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}" : "";
    String formattedTime = selectedTime!=null? "${selectedTime!.hour}:${selectedTime!.minute}" : "";

    Trip newTrip = Trip(
      about: Profile.userData['about'] ?? '',
      createdBy: Profile.userData['id'] ?? '',
      date: formattedDate,
      desc: description != "" ? description : 'Not Available',
      destination: toLocation,
      modeOfTransport: transportationMode ?? 'Not decided',
      source: fromLocation,
      time: formattedTime,
      userImage: Profile.userData['profilePhoto'] ?? '',
      username: Profile.userData['username'] ?? '',
    );

    try {
      await FirebaseFirestore.instance.collection('Trips').add({
        'about': newTrip.about,
        'createdBy': newTrip.createdBy,
        'date': newTrip.date,
        'desc': newTrip.desc,
        'destination': newTrip.destination,
        'modeOfTransport': newTrip.modeOfTransport,
        'source': newTrip.source,
        'time': newTrip.time,
        'userImage': newTrip.userImage,
        'username': newTrip.username,
      });
      print("Post created successfully!");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    } catch (e) {
      print("Error creating post: $e");
      // Handle the error as needed
    }
  }
}
