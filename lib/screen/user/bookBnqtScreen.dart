import 'package:flutter/material.dart';

class BookBnqtScreen extends StatefulWidget {
  final List<DateTime> unavailableDates;

  const BookBnqtScreen({required this.unavailableDates, super.key});

  @override
  State<BookBnqtScreen> createState() => _BookBnqtScreenState();
}

class _BookBnqtScreenState extends State<BookBnqtScreen> {
  String selectedEventType = "wedding";
  List<DateTime> selectedDates = [];
  List<String> selectedServices = [];
  final Map<String, int> serviceCosts = {
    "Main Banquet Hall": 50000,
    "Green Lawn Area": 30000,
    "AC Rooms": 10000,
    "Common Washrooms": 2000,
    "Parking Space": 5000,
    "Kitchen": 15000,
    "Stage Setup": 8000,
    "Hall Furniture": 7000,
    "Lighting & Power": 10000,
  };

  int calculateTotalCost() {
    final serviceCost = selectedServices.fold<int>(
      0,
      (sum, service) => sum + (serviceCosts[service] ?? 0),
    );
    return serviceCost * selectedDates.length;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      selectableDayPredicate: (date) {
        // Disable unavailable dates
        return !widget.unavailableDates.contains(date);
      },
    );
    if (pickedDate != null && !selectedDates.contains(pickedDate)) {
      setState(() {
        selectedDates.add(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banquet Booking'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Types
            const Text(
              "Event Types:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  EventType(
                    label: "Wedding",
                    isSelected: selectedEventType == "wedding",
                    onTap: () {
                      setState(() {
                        selectedEventType = "wedding";
                      });
                    },
                  ),
                  EventType(
                    label: "Birthday",
                    isSelected: selectedEventType == "birthday",
                    onTap: () {
                      setState(() {
                        selectedEventType = "birthday";
                      });
                    },
                  ),
                  EventType(
                    label: "Corporate",
                    isSelected: selectedEventType == "corporate",
                    onTap: () {
                      setState(() {
                        selectedEventType = "corporate";
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Dates:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text(
                    "Choose Dates",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: selectedDates
                  .map((date) => Chip(
                        label: Text("${date.day}/${date.month}/${date.year}"),
                        onDeleted: () {
                          setState(() {
                            selectedDates.remove(date);
                          });
                        },
                      ))
                  .toList(),
            ),
            const Divider(height: 32, thickness: 1),

            // Services List
            Expanded(
              child: ListView(
                children: serviceCosts.keys.map((service) {
                  return BnqtService(
                    title: service,
                    about: "Details about $service.",
                    isSelected: selectedServices.contains(service),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          selectedServices.add(service);
                        } else {
                          selectedServices.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final totalCost = calculateTotalCost();
                  print("Selected Event Type: $selectedEventType");
                  print("Selected Dates: $selectedDates");
                  print("Selected Services: $selectedServices");
                  print("Total Cost: $totalCost");
                  // Add your logic for "Proceed" here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventType extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const EventType({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BnqtService extends StatelessWidget {
  final String title;
  final String about;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const BnqtService({
    required this.title,
    required this.about,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    about,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(value: isSelected, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
