import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final name = appointment['name'] ?? 'No Name';
    final contact = appointment['contact'] ?? 'No Contact Info';
    final date = appointment['formattedDate'] ?? 'No Date';
    final time = appointment['time'] ?? 'No Time';
    final eventType = appointment['eventType'] ?? 'No Event Type';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.event, size: 36, color: Colors.blue),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact: $contact'),
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Event Type: $eventType'),
          ],
        ),

        //trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        // onTap: () {
        //   _showAppointmentDetails(context, appointment);
        // },
      ),
    );
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
