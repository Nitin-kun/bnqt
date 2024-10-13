import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Carousel package
import 'package:lakebenquet/screen/user/bookappointment.dart';
import 'package:lakebenquet/screen/user/bookbenquethallscreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; // Date picker package
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'lib/assets/images/1.png',
    'lib/assets/images/2.jpg',
    'lib/assets/images/3.jpg',
    'lib/assets/images/4.jpg',
  ];

  List<DateTime> unavailableDates = []; // List to store unavailable dates

  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://bnqt-d1772-default-rtdb.asia-southeast1.firebasedatabase.app/', // Custom Firebase URL
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
      final DataSnapshot snapshot = await _database.child('unavailable_dates').get();
      if (snapshot.exists) {
        List<dynamic> dateStrings = snapshot.value as List<dynamic>;
        setState(() {
          unavailableDates = dateStrings.map((dateString) {
            return DateTime.parse(dateString); // Parse the date strings back to DateTime
          }).toList();
        });
        print(unavailableDates);
        // Print fetched dates for debugging
      }
    } catch (error) {
      print('Failed to fetch unavailable dates: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch unavailable dates: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Lake Garden Banquet Hall',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Image Carousel
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: imgList.map((item) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(item),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Description Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Lake Garden Banquet Hall is a spacious venue for your special events. "
              "We offer a beautifully designed hall and green lawn to make your gatherings memorable.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 20),

          // Booking Calendar Section
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Date marked in red are unavailable ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),

          // Syncfusion DateRangePicker with special unavailable dates
          SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.single, // Only view, no multi-selection
            monthViewSettings: DateRangePickerMonthViewSettings(
              specialDates: unavailableDates, // Mark unavailable dates
            ),
            monthCellStyle: const DateRangePickerMonthCellStyle(
              specialDatesDecoration: BoxDecoration(
                color: Colors.red, // Color for unavailable dates
                shape: BoxShape.circle,
              ),
            ),
            
            onSelectionChanged: (args) {
              if (args.value is DateTime) {
                // Do something with the selected date
                print(unavailableDates);
              }
            },
          ),

          const SizedBox(height: 20),

          // Booking Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Button to book an appointment
              ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.green, // Green color for appointment booking
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Book Appointment"),
              ),

              // Button to book the venue
              ElevatedButton(
                onPressed: _bookVenue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.orange, // Orange color for venue booking
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Book Venue"),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Method to navigate to the booking appointment screen
  void _bookAppointment() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const BookAppointmentScreen() ));
    // TODO: Implement the navigation to the appointment booking screen
    print('Navigate to the appointment booking screen.');
  }

  // Method to navigate to the venue booking screen
  void _bookVenue() {
    // TODO: Implement the navigation to the venue booking screen
    Navigator.push(context, MaterialPageRoute(builder: (context)=>  BookBanquetHallScreen() ));
    print('Navigate to the venue booking screen.');
  }
}
