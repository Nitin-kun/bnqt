import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('welcom to lake garden '),
      ),
      body: Column(
        children: [
    

TableCalendar(
  firstDay: DateTime.utc(2024),
  lastDay: DateTime.utc(2030, 3, 14),
  focusedDay: DateTime.now(),
  calendarFormat: CalendarFormat.month,
  onFormatChanged: (format) {
    // Handle format change if needed
  },
  availableCalendarFormats: const {
    CalendarFormat.month: 'Month',
     
  },
)

        ],
      ),
    );
  }
}
