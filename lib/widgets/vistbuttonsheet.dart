import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//flutter build apk --release

void showBookingBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return const BookingBottomSheet();
    },
  );
}

class BookingBottomSheet extends StatefulWidget {
  const BookingBottomSheet({super.key});

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Book a Visit",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Date Selection
          TextField(
            decoration: InputDecoration(
              labelText: selectedDate == null
                  ? "Select Date"
                  : DateFormat('dd MMM, yyyy').format(selectedDate!),
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 16),

          // Time Selection
          TextField(
            decoration: InputDecoration(
              labelText: selectedTime == null
                  ? "Select Time"
                  : selectedTime!.format(context),
              border: const OutlineInputBorder(),
              suffixIcon: const Icon(Icons.access_time),
            ),
            readOnly: true,
            onTap: () => _selectTime(context),
          ),
          const SizedBox(height: 16),

          // Confirm Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Visit Booked Successfully!")),
              );
            },
            child: const Text("Confirm", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
