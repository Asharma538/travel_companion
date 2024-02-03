import 'package:flutter/material.dart';
import 'package:travel_companion/utils/colors.dart';
import '../pages/search_results.dart';

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
  const SearchPage({super.key});

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
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "FROM",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: fromLocationController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: textFieldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Ex: Jodhpur",
                hintStyle: const TextStyle(
                  color: placeholderTextColor,
                ),
              ),
            ),
            SizedBox(width: screenSize.width * 0.5),
            const Text(
              "TO",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: toLocationController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: textFieldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Ex: Airport",
                hintStyle: const TextStyle(
                  color: placeholderTextColor,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  height: 45,
                  onPressed: () => _showDatePicker(context, (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  }),
                  color: textFieldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : "DATE",
                      style: const TextStyle(
                        color: placeholderTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  height: 45,
                  onPressed: () =>
                      _showTimePicker(context, selectedTime, (time) {
                    setState(() {
                      selectedTime = time;
                    });
                  }),
                  color: textFieldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      selectedTime != null
                          ? "${selectedTime!.hour}:${selectedTime!.minute}"
                          : "TIME",
                      style: const TextStyle(
                        color: placeholderTextColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.02),
            const Text(
              "MODE OF TRANSPORTATION",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: modeOfTransportController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: textFieldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Ex: Flight/Train/Taxi/Auto etc.",
                hintStyle: const TextStyle(
                  color: placeholderTextColor,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            const Text(
              "DESCRIPTION",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: 2,
              decoration: InputDecoration(
                filled: true,
                fillColor: textFieldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Ex: Fight name or no./Train name or no.",
                hintStyle: const TextStyle(
                  color: placeholderTextColor,
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  String fromLocation = fromLocationController.text;
                  String toLocation = toLocationController.text;
                  String modeOfTransport = modeOfTransportController.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(
                          fromLocation: fromLocation,
                          toLocation: toLocation,
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          modeOfTransport: modeOfTransport
                        )
                      )
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(30, 6, 30, 6),
                  backgroundColor: complementaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "GO",
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 25.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
