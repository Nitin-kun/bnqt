import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class BookBanquetHallScreen extends StatefulWidget {
  @override
  _BookBanquetHallScreenState createState() => _BookBanquetHallScreenState();
}

class _BookBanquetHallScreenState extends State<BookBanquetHallScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _bookingDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  
  bool _centralizedHallSelected = true;
  bool _additionalHallSelected = false;
  bool _lawnSelected = false;
  bool _lightingArrangements = true;
  
  int _numSofas = 9;
  int _banquetChairs = 50;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Banquet Hall'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateTimeSection(),
              _buildHallSelectionSection(),
              _buildFurnitureSection(),
              _buildExtraServicesSection(),
              _buildPricingSummary(),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Section to select date and time
  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Booking Date:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        SfDateRangePicker(
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            setState(() {
              _bookingDate = args.value;
            });
          },
          selectionMode: DateRangePickerSelectionMode.single,
        ),
        const SizedBox(height: 20),
        // Add time pickers for start and end time
      ],
    );
  }

  // Section to select hall
  Widget _buildHallSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Halls:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        CheckboxListTile(
          title: const Text("Centralised AC Banquet Hall (5000 sq. ft.)"),
          value: _centralizedHallSelected,
          onChanged: (value) {
            setState(() {
              _centralizedHallSelected = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Additional Hall (2000 sq. ft.)"),
          value: _additionalHallSelected,
          onChanged: (value) {
            setState(() {
              _additionalHallSelected = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text("Lawn (18000 sq. ft.)"),
          value: _lawnSelected,
          onChanged: (value) {
            setState(() {
              _lawnSelected = value!;
            });
          },
        ),
      ],
    );
  }

  // Furniture and amenities section
  Widget _buildFurnitureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Furniture:', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sofas in Hall"),
            DropdownButton<int>(
              value: _numSofas,
              onChanged: (int? newValue) {
                setState(() {
                  _numSofas = newValue!;
                });
              },
              items: [5, 9, 12].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Banquet Chairs"),
            DropdownButton<int>(
              value: _banquetChairs,
              onChanged: (int? newValue) {
                setState(() {
                  _banquetChairs = newValue!;
                });
              },
              items: [50, 100, 150].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }

  // Pricing summary and confirm button
  Widget _buildPricingSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text("Estimated Total: \$_totalCost"),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle booking logic here
      },
      child: const Text('Confirm Booking'),
    );
  }

  // Section for selecting extra services
Widget _buildExtraServicesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Extra Services:', style: TextStyle(fontSize: 18)),
      const SizedBox(height: 10),
      
      // Lighting arrangements
      CheckboxListTile(
        title: const Text("Lighting Arrangements (In-built lights in hall, lawn, stall, kitchen)"),
        value: _lightingArrangements,
        onChanged: (value) {
          setState(() {
            _lightingArrangements = value!;
          });
        },
      ),
      
      // Power supply with extra diesel cost
      ListTile(
        title: const Text("Generator Power Supply (from 06:30 PM, extra diesel cost: 20 LTR/Hour)"),
      ),
      
      // Security guards selection
      ListTile(
        title: const Text("Security Guards (4 Nos)"),
      ),

      // Parking information
      ListTile(
        title: const Text("150+ Car Parking Available"),
      ),
      
      // Kitchen
      ListTile(
        title: const Text("Kitchen Access (3000 sq. ft.)"),
      ),
    ],
  );
}

}
