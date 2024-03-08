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
  String dropdownValue = 'Flexible';

  TextEditingController fromLocationController = TextEditingController();
  TextEditingController toLocationController = TextEditingController();
  TextEditingController modeOfTransportController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
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
                  color: primaryTextColor,
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
              const SizedBox(height: 15),
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
                  color: primaryTextColor,
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
              const SizedBox(height: 25),
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
                    color: secondaryColor,
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
                          color: secondaryTextColor,
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
                    color: secondaryColor,
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
                          color: secondaryTextColor,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                "Mode of Transport",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  underline: const SizedBox(
                    height: 0,
                  ),
                  value: dropdownValue,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: secondaryTextColor,
                  ),
                  isExpanded: true,
                  items: ['Flexible', 'Flight', 'Train', 'Taxi', 'Bus']
                      .map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: secondaryTextColor),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  dropdownColor: secondaryColor,
                ),
              ),
              const Expanded(child: SizedBox()),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    String fromLocation = fromLocationController.text;
                    String toLocation = toLocationController.text;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchResultsPage(
                                fromLocation: fromLocation,
                                toLocation: toLocation,
                                selectedDate: selectedDate,
                                selectedTime: selectedTime,
                                modeOfTransport: dropdownValue)));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(50, 6, 50, 6),
                    backgroundColor: complementaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "GO",
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 25,
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
