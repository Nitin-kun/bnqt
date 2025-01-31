import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/appointmentcard.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _selectedDate =
      DateTime.now(); // Holds the currently selected date for filtering

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Appointments'),
        centerTitle: true,
        actions: [
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         _selectedDate;
          //       });
          //     },
          //     icon: Icon(Icons.restore)),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _pickDate, // Open the date picker
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('appointments')
            .orderBy('date') // Order by date
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No appointments available!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Filter appointments by selected date
          final filteredAppointments = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((appointment) {
            String formattedDate = appointment['formattedDate'] ?? '';
            return formattedDate ==
                DateFormat('yyyy-MM-dd').format(_selectedDate);
          }).toList();

          if (filteredAppointments.isEmpty) {
            return const Center(
              child: Text(
                'No appointments found for the selected date.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Build appointment list
          return ListView.builder(
            itemCount: filteredAppointments.length,
            itemBuilder: (context, index) {
              // Function to convert time to DateTime
              DateTime convertTimeToDateTime(String time) {
                // Assuming the time is in format "h:mm a" (e.g., "10:00 AM")
                final dateFormat = DateFormat(
                    "h:mm a"); // DateFormat used to parse the time string
                return dateFormat.parse(time);
              }

              filteredAppointments.sort((a, b) {
                // Convert the time to DateTime for comparison
                DateTime timeA = convertTimeToDateTime(a['time']);
                DateTime timeB = convertTimeToDateTime(b['time']);

                // Compare the times
                return timeA.compareTo(timeB);
              });

// Printing the sorted filteredAppointments
              for (var appointment in filteredAppointments) {
                print('${appointment['name']} at ${appointment['time']}');
              }
              final appointment = filteredAppointments[index];
              return AppointmentCard(appointment: appointment); // Custom widget
            },
          );
        },
      ),
    );
  }

  // Function to show a DatePicker and update the selected date
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to show detailed appointment information in a dialog
  void _showAppointmentDetails(
      BuildContext context, Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appointment['name'] ?? 'Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact: ${appointment['contact'] ?? 'N/A'}'),
            Text('Date: ${appointment['date'] ?? 'N/A'}'),
            Text('Time: ${appointment['time'] ?? 'N/A'}'),
            Text('Event Type: ${appointment['eventType'] ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
