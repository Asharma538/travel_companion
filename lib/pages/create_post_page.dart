import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff302360),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "New Post",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("FROM", "Ex: Jodhpur", (value) {
              fromLocation = value;
            }),
            SizedBox(height: _mediaQuery.size.height * 0.02),
            _buildTextField("TO", "Ex: Airport", (value) {
              toLocation = value;
            }),
            SizedBox(height: _mediaQuery.size.height * 0.02),
            _buildDateTimeRow(),
            SizedBox(height: _mediaQuery.size.height * 0.02),
            _buildTextField("MODE OF TRANSPORTATION", "Ex: Flight/Train/Taxi/Auto etc.", (value) {
              transportationMode = value;
            }),
            SizedBox(height: _mediaQuery.size.height * 0.02),
            _buildTextField("DESCRIPTION", "Ex: Flight name or no./Train name or no.", (value) {
              description = value;
            }, maxLines: 2),
            SizedBox(height: _mediaQuery.size.height * 0.02),
            ElevatedButton(
              onPressed: () {
                print('From Location: $fromLocation');
                print('To Location: $toLocation');
                print('Date: $selectedDate');
                print('Time: $selectedTime');
                print('Transportation Mode: $transportationMode');
                print('Description: $description');
              },
              child: Text(
                "Create Post",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff302360),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged, {int? maxLines}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          onChanged: onChanged,
          style: TextStyle(
            color: Colors.black,
          ),
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              color: Color(0xffA0A0A0),
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
      minWidth: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.076,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(width: 8.0),
          Text(
            selectedDate != null && label == "DATE"
                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                : selectedTime != null && label == "TIME"
                ? "${selectedTime!.hour}:${selectedTime!.minute}"
                : label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
      color: Color(0xff302360),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide.none,
      ),
    );
  }
}
