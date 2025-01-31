import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class EditCalander extends StatefulWidget {
  const EditCalander({super.key});

  @override
  State<EditCalander> createState() => _EditCalanderState();
}

class _EditCalanderState extends State<EditCalander> {
  List<DateTime> selectedDates = [];
  List<DateTime> unavailableDates = [];

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://bnqt-d1772-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).ref();

  @override
  void initState() {
    super.initState();
    _fetchUnavailableDates();
  }

  Future<void> _fetchUnavailableDates() async {
    try {
      final DataSnapshot snapshot =
          await _database.child('unavailable_dates').get();
      if (snapshot.exists) {
        List<dynamic> dateStrings = snapshot.value as List<dynamic>;
        setState(() {
          unavailableDates = dateStrings
              .map((dateString) => DateTime.parse(dateString))
              .toList();
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch dates: $error')));
    }
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   if (args.value is List<DateTime>) {
  //     setState(() {
  //       selectedDates = args.value;
  //     });
  //   }
  // }

  Future<void> _saveDatesToFirebase() async {
    if (selectedDates.isNotEmpty) {
      Set<DateTime> combinedDates = {...unavailableDates, ...selectedDates};
      List<String> dateStrings = combinedDates
          .map((date) => DateFormat('yyyy-MM-dd').format(date))
          .toList();

      try {
        await _database.child('unavailable_dates').set(dateStrings);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dates saved successfully!')));
        setState(() {
          unavailableDates = combinedDates.toList();
          selectedDates = [];
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save dates: $error')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No dates selected!')));
    }
  }

  Future<void> _removeDateFromFirebase(DateTime date) async {
    setState(() {
      unavailableDates.remove(date);
    });

    List<String> updatedDates = unavailableDates
        .map((date) => DateFormat('yyyy-MM-dd').format(date))
        .toList();
    try {
      await _database.child('unavailable_dates').set(updatedDates);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Date removed successfully!')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove date: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Dates')),
      body: Column(
        children: [
          // SfDateRangePicker(
          //   view: DateRangePickerView.month,
          //   selectionMode: DateRangePickerSelectionMode.multiple,
          //   onSelectionChanged: _onSelectionChanged,
          //   initialSelectedDates: unavailableDates,
          //   monthViewSettings: DateRangePickerMonthViewSettings(
          //       specialDates: unavailableDates),
          //   monthCellStyle: const DateRangePickerMonthCellStyle(
          //     specialDatesDecoration:
          //         BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
          //   ),
          // ),
          const SizedBox(height: 20),
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
                          title: Text(formattedDate),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeDateFromFirebase(
                                unavailableDates[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveDatesToFirebase,
              child: const Text('Save Dates to Firebase'),
            ),
          ),
        ],
      ),
    );
  }
}
