import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_companion/pages/home.dart';
import 'package:travel_companion/utils/colors.dart';
import '../main.dart';
import '../pages/profile.dart';

class Trip {
  final DocumentReference userRef;
  final String date;
  final String desc;
  final String destination;
  final String modeOfTransport;
  final String source;
  final String time;
  final DateTime createdDateTime;

  Trip({
    required this.userRef,
    required this.date,
    required this.desc,
    required this.destination,
    required this.modeOfTransport,
    required this.source,
    required this.time,
    required this.createdDateTime,
  });
}

class CreatePostPage extends StatefulWidget {
  final Map<String, dynamic>? initialPost;
  const CreatePostPage({Key? key, this.initialPost}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String dropdownValue = 'Flexible';

  String fromLocation = '';
  String toLocation = '';
  String transportationMode = 'Flexible';
  String description = '';

  void _showDatePicker(BuildContext context,
      Function(DateTime) onDateSelected) {
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
  void initState() {
    super.initState();
    if (widget.initialPost != null) {
      fromLocation = widget.initialPost!['source'] ?? '';
      toLocation = widget.initialPost!['destination'] ?? '';
      transportationMode = widget.initialPost!['modeOfTransport'] ?? '';
      description = widget.initialPost!['desc'] ?? '';
      String dateString = widget.initialPost!['date'] ?? '';
      List<String> dateParts = dateString.split('-');
      int day = int.parse(dateParts[2]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[0]);
      selectedDate = DateTime(year, month, day);

      selectedTime = TimeOfDay(
        hour: int.parse(widget.initialPost!['time'].split(':')[0]),
        minute: int.parse(widget.initialPost!['time'].split(':')[1]),
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryTextColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: widget.initialPost != null
            ? const Text(
                "Edit Post",
                style: TextStyle(fontWeight: FontWeight.w500,color: secondaryTextColor),
              )
            : const Text(
                "New Post",
                style: TextStyle(fontWeight: FontWeight.w500,color: secondaryTextColor),
              ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("FROM", fromLocation, "Ex: Jodhpur", (value) {
              fromLocation = value;
            }),
            const SizedBox(height: 25),
            _buildTextField("TO", toLocation, "Ex: Airport", (value) {
              toLocation = value;
            }),
            const SizedBox(height: 35),
            _buildDateTimeRow(),
            const SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton(
                underline: const SizedBox(height: 0,),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                value: transportationMode,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down,color: secondaryTextColor,),
                items:
                    ['Flexible', 'Flight', 'Train', 'Taxi', 'Bus'].map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    transportationMode = newValue!;
                  });
                },
                dropdownColor: secondaryColor,
              ),
            ),
            const SizedBox(height: 15),
            const Expanded(child: SizedBox()),
            Center(
              child: TextButton(
                onPressed: () async {
                  try {
                    await createNewTrip(context);
                  } catch (e) {
                    print("Error creating post : $e");
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: complementaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                  width: 130,
                  child: Text(
                    widget.initialPost==null? "Create Post" : "Edit Post",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String initialText, String hint, Function(String) onChanged,
      {int? maxLines}) {
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
          controller: TextEditingController()..text = initialText,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateTimeButton("DATE", Icons.calendar_today, () {
          _showDatePicker(context, (date) {
            setState(() {
              selectedDate = date;
            });
          });
        }),
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
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
      minWidth: MediaQuery.of(context).size.width * 0.4,
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
                ? selectedDate.toString().substring(0, 10)
                : selectedTime != null && label == "TIME"
                    ? "${selectedTime!.hour}:${selectedTime!.minute}"
                    : label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createNewTrip(BuildContext context) async {
    if (fromLocation.isEmpty || toLocation.isEmpty) {
      print("Please fill all the required fields"); return;
    }

    String userEmail = Profile.userData['id'];
    String formattedDate =
        selectedDate != null ? selectedDate.toString().substring(0, 10) : "";
    String formattedTime = selectedTime != null
        ? "${selectedTime!.hour}:${selectedTime!.minute}" : "";

    Trip newTrip = Trip(
      userRef: FirebaseFirestore.instance.collection('Users').doc(userEmail),
      date: formattedDate,
      desc: description != "" ? description : 'Not Available',
      destination: toLocation,
      modeOfTransport: transportationMode ?? 'Not decided',
      source: fromLocation,
      time: formattedTime,
      createdDateTime: DateTime.now(),
    );

    try {
      if (widget.initialPost != null) {
        await FirebaseFirestore.instance
            .collection('Trips')
            .doc(widget.initialPost!['id'])
            .update({
          'userRef': newTrip.userRef,
          'date': newTrip.date,
          'desc': newTrip.desc,
          'destination': newTrip.destination,
          'modeOfTransport': newTrip.modeOfTransport,
          'source': newTrip.source,
          'time': newTrip.time,
          'createdBy': userEmail,
        });
        Navigator.pushAndRemoveUntil(
            context,

            MaterialPageRoute(builder: (context) => const Base()),

            (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Post Updated')));
      }
      else {
        await FirebaseFirestore.instance.collection('Trips').add({
          'userRef': newTrip.userRef,
          'date': newTrip.date,
          'desc': newTrip.desc,
          'destination': newTrip.destination,
          'modeOfTransport': newTrip.modeOfTransport,
          'source': newTrip.source,
          'time': newTrip.time,
          'createdBy': userEmail,
          'createdDateTime': newTrip.createdDateTime,
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Base()),
            (route) => false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('New Post Created!')));
      }
    } catch (e) {
      print("Error creating post: $e");
    }
  }
}
