import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lakebenquet/widgets/button.dart'; // For formatting date and time

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  static const String dateFormatString = 'MMM dd, yyyy';
  static const String timeFormatString = 'hh:mm a';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _selectedEventType;

  final List<String> eventType = ['Wedding', 'Party', 'Conference', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now(); // Set initial date and time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimePicker(),
              _buildNameField(),
              _buildContactField(),
              _buildEventTypeDropdown(),
              const SizedBox(height: 20),
              Center(child: _buildConfirmButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date and Time:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickDateTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateTime == null
                      ? 'Select Date & Time'
                      : '${DateFormat(dateFormatString).format(_selectedDateTime!)} at ${DateFormat(timeFormatString).format(_selectedDateTime!)}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Icon(Icons.calendar_today, color: Colors.orange),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Widget _buildEventTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Select Event Type:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedEventType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedEventType = newValue;
            });
          },
          items: eventType.map<DropdownMenuItem<String>>((String event) {
            return DropdownMenuItem<String>(
              value: event,
              child: Text(event),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Event Type',
            prefixIcon: Icon(Icons.event, color: Colors.orange),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an event type';
            }
            return null;
          },
        ),
      ],
    );
  }

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
            prefixIcon: Icon(Icons.person, color: Colors.orange),
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
            prefixIcon: Icon(Icons.phone, color: Colors.orange),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact number';
            } else if (value.length != 10 || int.tryParse(value) == null) {
              return 'Contact number must be 10 digits and numeric';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return BnqtButton(
      text: "Confirm Appointment",
      onPressed: _bookAppointment,
    );
  }

  void _bookAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {}); // Start loading state

      try {
        // Retrieve user inputs
        String name = _nameController.text.trim();
        String contact = _contactController.text.trim();
        DateTime selectedDateTime = _selectedDateTime!; // Full date and time
        String formattedDate = DateFormat('yyyy-MM-dd')
            .format(selectedDateTime); // Simplified date
        String formattedTime = DateFormat('hh:mm a').format(selectedDateTime);

        // Generate Firestore document
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('appointments')
            .doc(); // Auto-generate a unique document ID

        // Save appointment to Firestore
        await docRef.set({
          'name': name,
          'contact': contact,
          'date': Timestamp.fromDate(selectedDateTime), // Firestore Timestamp
          'formattedDate': formattedDate, // Simplified string for filtering
          'time': formattedTime,
          'eventType': _selectedEventType,
          'createdAt':
              FieldValue.serverTimestamp(), // For tracking creation time
        });

        // Send FCM notification with appointment details
        await sendFCMNotification(name, contact, formattedDate, formattedTime);

        // Success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment successfully booked!')),
        );

        // Close the form after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } catch (error) {
        // Error feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: $error')),
        );
      } finally {
        setState(() {}); // End loading state
      }
    }
  }

  Future<void> sendFCMNotification(
      String name, String contact, String date, String time) async {
    // Define the bearer token and API endpoint
    const token =
        'ya29.c.c0ASRK0GbRo5zUn469AAzo69YrooyfYTJ_nKOV1bYOvAm7XY0E2Q1czmFnDebJZS2PH6u3WwrYiTur3l1XY0DHcf8P-z5KASoeIjB0uZebw3E6eEf2XX8UbGSY-DWfuacW-Fi30552Mht17LqLGYeyQ6csjwaNTWjFFKpw96lokTO5UdhfmMz0pI4DosH2zQeF-P01F6Gm7RCoPLhX4n8vJCAkpFYWgrTEYX4XKh06lfNeNG46rFHR1-RfB7m1Ufmm4nZD0-szO_QEH9spzXztaX1qqSqapOqIpsA__G0RFA8TcstFaLAn3IFRFegfTByg3ozq9R_G7CrUsmpIc4mL63zFp87KBu2Gz3T7Uj4BIW06VsY48yviRVGLL385CV8XxlvX2bXp1uu7m3Zg3Q799Wk3-YgznnMnOgee0qi9Y8MR37xe5BiZ0ubbWsRfd4-iO9zl66_a09xVkSBI-aVQ7YuQSZhFBVpRQsi03xOf3_QS5R1OVn44bhVS6o9f1kR-JBOUrzkrXtj3ruOBOWkZW9lx0l2XeJ8wcFxUV9z0rX5Ji_tMuUlXuaXcoU8xXxaZZn7g2Wrzmmd-xlvfRuwmgsB5My4OOFUqSYMW6SpvBprjQ4ReYfn16tQYi-15BwYtydc72n660bkIM9iW7Qo-6OtX_i6QS42RB3r4BywtaSV3h-6xQbRWBb_xezkFJgv3aR7_jUwlcYta33kfomb2m1cgpYg75Vtsbj1l6ajRp362O0fZy5F5ovhopi_14wfwcjcfUghbSg6ynvpxu3QJ2irb9OxQ1rv3jxvrIkUk82m_582bnSSMjjhUc9Z0pjJeI0ZBSxmO3Wivc7Sj8fSjoxF_s-np9WYv63FIaVVtcasgwZhihlyQonkzBoR9ZdFtU4J_-3jQljy0dOw5vYpenqIc3wn4lrJtk-3Qp1bi1ZZR83j0dtl8OqBspSZ9lIR2cOZBabU6RUZnjyuFo_k2Xn1w2lZt8ao9OseXgquJwouq8SykBMdrr9Y'; // Replace with actual token
    const url =
        'https://fcm.googleapis.com/v1/projects/bnqt-d1772/messages:send';

    final Map<String, dynamic> messagePayload = {
      "message": {
        "topic": "topicAdmin", // Topic to send the notification to
        "notification": {
          "title": "New Appointment Booked!",
          "body": "Name: $name\nContact: $contact\nDate: $date\nTime: $time",
        },
        "android": {
          "priority": "high",
          "notification": {
            "channel_id": "high_importance_channel",
          },
        },
      },
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(messagePayload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully!');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
}
