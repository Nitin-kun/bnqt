// For platform check
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; // Date picker package
import 'package:intl/intl.dart'; // For formatting date
// For launching WhatsApp

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // Constants
  static const String dateFormatString = 'dd/MM/yyyy';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime? _appointmentDate;
  String? _selectedTime;

  // Available times for booking
  final List<String> availableTimes = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _appointmentDate = DateTime.now();
    _selectedTime = availableTimes[0]; // Set default time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book an Appointment',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              _buildDateDisplay(),
              _buildTimeDropdown(),
              _buildNameField(),
              _buildContactField(),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build date picker
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        SfDateRangePicker(
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            setState(() {
              _appointmentDate = args.value;
            });
          },
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: DateTime.now(),
        ),
      ],
    );
  }

  // Method to display selected date
  Widget _buildDateDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Selected Date: ${DateFormat(dateFormatString).format(_appointmentDate ?? DateTime.now())}',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  // Method to build time dropdown
  Widget _buildTimeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Select Time:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedTime,
          onChanged: (String? newValue) {
            setState(() {
              _selectedTime = newValue;
            });
          },
          items: availableTimes.map<DropdownMenuItem<String>>((String time) {
            return DropdownMenuItem<String>(
              value: time,
              child: Text(time),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Select Time',
          ),
        ),
      ],
    );
  }

  // Method to build name field
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Method to build contact field
  Widget _buildContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: _contactController,
          maxLength: 10,
          decoration: const InputDecoration(
            labelText: 'Contact Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact number';
            } else if (value.length != 10) {
              return 'Contact number must be 10 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Method to build confirm button
  Widget _buildConfirmButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _bookAppointment,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.green,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text("Confirm Appointment"),
        ),
      ],
    );
  }

  // Method to handle the appointment booking
  void _bookAppointment() {
    if (_formKey.currentState!.validate()) {
      // Collect form data
      String name = _nameController.text;
      String contact = _contactController.text;
      String formattedDate =
          DateFormat(dateFormatString).format(_appointmentDate!);

      // Firebase Database reference
      final DatabaseReference db = FirebaseDatabase.instanceFor(
              app: Firebase.app(),
              databaseURL:
                  'https://bnqt-d1772-default-rtdb.asia-southeast1.firebasedatabase.app/') // Replace with your Firebase Database URL
          .ref();

      String timestamp = DateFormat('yyyyMMddHHmmss')
          .format(DateTime.now()); // Generate timestamp as key

      db.child('appointments/$timestamp').set({
        'name': name,
        'contact': contact,
        'date': formattedDate,
        'time': _selectedTime,
      }).then((_) {
        // Success - Show confirmation dialog or toast
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment successfully booked!')),
        );
      }).catchError((error) {
        // Failure - Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: $error')),
        );
      });

      // // Push appointment details to Firebase
      // _db.child('appointments').push().set({
      //   'name': name,
      //   'contact': contact,
      //   'date': formattedDate,
      //   'time': _selectedTime,
      // }).then((_) {
      //   // Success - Show confirmation dialog or toast
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Appointment successfully booked!')),
      //   );
      // }).catchError((error) {
      //   // Failure - Show error message
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Failed to book appointment: $error')),
      //   );
      // });
    }
  }
}
