import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_companion/utils/colors.dart';
import '../pages/profile.dart';
import '../main.dart';

class Trip {
  final DocumentReference userRef;
  final String date;
  final String desc;
  final String destination;
  final String modeOfTransport;
  final String source;
  final String time;

  Trip({
    required this.userRef,
    required this.date,
    required this.desc,
    required this.destination,
    required this.modeOfTransport,
    required this.source,
    required this.time,
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

  void _showDatePicker(BuildContext context, Function(DateTime) onDateSelected) {
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

  void _showTimePicker(BuildContext context, TimeOfDay? selectedTime,Function(TimeOfDay) onTimeSelected) async {
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
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);
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
    var _mediaQuery = MediaQuery.of(context);
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
        title: widget.initialPost != null
            ? const Text(
                "Edit Post",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : const Text(
                "New Post",
                style: TextStyle(fontWeight: FontWeight.bold),
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
            SizedBox(height: _mediaQuery.size.height * 0.02),
            _buildTextField("TO", toLocation, "Ex: Airport", (value) {
              toLocation = value;
            }),
            const SizedBox(height: 20),
            _buildDateTimeRow(),
            SizedBox(height: _mediaQuery.size.height * 0.02),
            Container(
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
                value: transportationMode,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['Flexible', 'Flight', 'Train','Taxi','Bus'].map((item) {
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
            SizedBox(height: _mediaQuery.size.height * 0.02),
            if (widget.initialPost == null) ...[
              const Expanded(child: SizedBox()),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await createNewTrip(context);
                    } catch (e) {
                      print("Error creating post : $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff302360),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    "Create Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              )
            ] else ...[
              ElevatedButton(
                onPressed: () async {
                  try {
                    await createNewTrip(context);
                  } catch (e) {
                    print("Error creating post: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff302360),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text(
                  "Edit Post",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ]
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDateTimeButton("DATE", Icons.calendar_today, () {
          _showDatePicker(context, (date) {
            setState(() {
              selectedDate = date;
            });
          });
        }),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1 - 16,
        ),
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

  Widget _buildDateTimeButton(
      String label, IconData icon, VoidCallback onPressed) {
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
    String userEmail = Profile.userData['id'];
    String formattedDate = selectedDate != null
        ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
        : "";
    String formattedTime = selectedTime != null
        ? "${selectedTime!.hour}:${selectedTime!.minute}"
        : "";

    Trip newTrip = Trip(
      userRef: await FirebaseFirestore.instance.collection('Users').doc(userEmail),
      date: formattedDate,
      desc: description != "" ? description : 'Not Available',
      destination: toLocation,
      modeOfTransport: transportationMode ?? 'Not decided',
      source: fromLocation,
      time: formattedTime,
    );

    try {
      if (widget.initialPost != null) {
        await FirebaseFirestore.instance.collection('Trips').doc(widget.initialPost!['id']).update({
          'userRef': newTrip.userRef,
          'date': newTrip.date,
          'desc': newTrip.desc,
          'destination': newTrip.destination,
          'modeOfTransport': newTrip.modeOfTransport,
          'source': newTrip.source,
          'time': newTrip.time,
          'createdBy':userEmail
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post Updated')));
      } else {
        await FirebaseFirestore.instance.collection('Trips').add({
          'userRef': newTrip.userRef,
          'date': newTrip.date,
          'desc': newTrip.desc,
          'destination': newTrip.destination,
          'modeOfTransport': newTrip.modeOfTransport,
          'source': newTrip.source,
          'time': newTrip.time,
          'createdBy':userEmail
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New Post Created!')));
      }
    } catch (e) {
      print("Error creating post: $e");
    }
  }
}
