import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class EditCalander extends StatefulWidget {
  const EditCalander({super.key});

  @override
  State<EditCalander> createState() => _EditCalanderState();
}

class _EditCalanderState extends State<EditCalander> {
  List<DateTime> selectedDates = []; // Dates selected by the admin
  List<DateTime> unavailableDates = []; // Dates fetched from Firebase

  // Firebase Realtime Database reference for your specific URL
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://bnqt-d1772-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).ref();

  @override
  void initState() {
    super.initState();
    // Fetch unavailable dates from Firebase when the screen loads
    _fetchUnavailableDates();
  }

  // Fetch the unavailable dates from Firebase
  Future<void> _fetchUnavailableDates() async {
    try {
      final DataSnapshot snapshot =
          await _database.child('unavailable_dates').get();
      if (snapshot.exists) {
        List<dynamic> dateStrings = snapshot.value as List<dynamic>;
        setState(() {
          unavailableDates = dateStrings.map((dateString) {
            return DateTime.parse(
                dateString); // Parse the date strings back to DateTime
          }).toList();
        });
        print(unavailableDates);
      }
    } catch (error) {
      print('Failed to fetch unavailable dates: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch unavailable dates: $error')),
      );
    }
  }

  // Method to handle date selection
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is List<DateTime>) {
      setState(() {
        selectedDates = args.value;
      });
    }
  }

  // Method to save the selected dates to Firebase and append to existing unavailable dates
  Future<void> _saveDatesToFirebase() async {
    if (selectedDates.isNotEmpty) {
      // Combine unavailable dates and selected dates, avoiding duplicates
      Set<DateTime> combinedDates = {...unavailableDates, ...selectedDates};

      // Convert DateTime objects to strings (only the date part) for Firebase storage
      List<String> dateStrings = combinedDates.map((date) {
        return DateFormat('yyyy-MM-dd')
            .format(date); // Format the date to 'yyyy-MM-dd'
      }).toList();

      try {
        // Save the combined dates to Firebase
        await _database.child('unavailable_dates').set(dateStrings);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dates saved successfully!')),
        );

        // After saving, update the unavailableDates list
        setState(() {
          unavailableDates = combinedDates.toList();
          selectedDates = []; // Clear selected dates after saving
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save dates: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No dates selected!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Dates'),
      ),
      body: Column(
        children: [
          // DateRangePicker with multi-selection enabled
          SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.multiple,
            onSelectionChanged: _onSelectionChanged, // Handle selection change
            initialSelectedDates: unavailableDates,
            // Pass unavailable dates to initialSelectedDates
            monthViewSettings: DateRangePickerMonthViewSettings(
              specialDates: unavailableDates,
            ),
            monthCellStyle: const DateRangePickerMonthCellStyle(
              specialDatesDecoration:
                  BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
            ),
          ),

          const SizedBox(height: 20),

          // Display the unavailable dates fetched from Firebase
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Unavailable Dates:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: unavailableDates.length,
                      itemBuilder: (context, index) {
                        String formattedDate = DateFormat('yyyy-MM-dd')
                            .format(unavailableDates[index]);
                        return ListTile(
                          title: Text(
                              formattedDate), // Display each unavailable date without time
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Button to save the selected dates to Firebase and append to the unavailable dates
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveDatesToFirebase, // Trigger saving dates
              child: const Text('Save Dates to Firebase'),
            ),
          ),
        ],
      ),
    );
  }
}
