import 'package:flutter/material.dart';

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

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();
  TextEditingController modeOfTransportController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 224, 227),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: const Text(
                  "FROM",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: fromLocationController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff302360),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Ex: Jodhpur",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 19, 201, 210),
                  ),
                ),
              ),
              SizedBox(width: _mediaQuery.size.width * 0.5),
              Text(
                "TO",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: toLocationController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff302360),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Ex: Airport",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 19, 201, 210),
                  ),
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    minWidth: _mediaQuery.size.width * 0.2,
                    height: _mediaQuery.size.height * 0.076,
                    onPressed: () => _showDatePicker(context, (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    }),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        selectedDate != null
                            ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                            : "DATE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    color: Color(0xff302360),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide.none,
                    ),
                  ),
                  MaterialButton(
                    minWidth: _mediaQuery.size.width * 0.2,
                    height: _mediaQuery.size.height * 0.076,
                    onPressed: () =>
                        _showTimePicker(context, selectedTime, (time) {
                      setState(() {
                        selectedTime = time;
                      });
                    }),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        selectedTime != null
                            ? "${selectedTime!.hour}:${selectedTime!.minute}"
                            : "TIME",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    color: Color(0xff302360),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _mediaQuery.size.height * 0.02),
              Text(
                "MODE OF TRANSPORTATION",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: modeOfTransportController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff302360),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Ex: Flight/Train/Taxi/Auto etc.",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 19, 201, 210),
                  ),
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.02),
              Text(
                "DESCRIPTION",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: descriptionController,
                style: TextStyle(
                  color: Colors.white,
                ),
                maxLines: 2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff302360),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Ex: Fight name or no./Train name or no.",
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 19, 201, 210),
                  ),
                ),
              ),
              SizedBox(height: _mediaQuery.size.height * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String fromLocation = fromLocationController.text;
                    String toLocation = toLocationController.text;
                    String modeOfTransport = modeOfTransportController.text;
                    String description = descriptionController.text;

                    // Use these values as needed
                    print("From: $fromLocation");
                    print("To: $toLocation");
                    print("Date: $selectedDate");
                    print("Time: $selectedTime");
                    print("Mode of Transport: $modeOfTransport");
                    print("Description: $description");
                  },
                  child: Text(
                    "GO",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

