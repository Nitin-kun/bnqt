import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lakebenquet/screen/user/bookappointment.dart';
import 'package:lakebenquet/screen/user/bookBnqtScreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
        'https://bnqt-d1772-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).ref();

  @override
  void initState() {
    super.initState();
    _fetchUnavailableDates();
  }

  // Fetch the unavailable dates from Firebase
  Future<void> _fetchUnavailableDates() async {
    try {
      final DataSnapshot snapshot =
          await _database.child('unavailable_dates').get();
      if (snapshot.exists) {
        List<dynamic> dateStrings = snapshot.value as List<dynamic>? ?? [];
        setState(() {
          unavailableDates = dateStrings.map((dateString) {
            return DateTime.parse(dateString);
          }).toList();
        });
        print('Fetched unavailable dates: $unavailableDates');
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
    // Get screen size
    final size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Lake Garden Banquet Hall',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUnavailableDates,
        child: ListView(
          // Use ListView to enable scrolling
          children: [
            // Image Carousel
            SizedBox(
              height: height * 0.3,
              width: width,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: imgList.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
            ),

            const SizedBox(height: 10),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Lake Garden Banquet Hall is a spacious venue for your special events. "
                "We offer a beautifully designed hall and green lawn to make your gatherings memorable.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),

            const SizedBox(height: 20),

            // Booking Calendar Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Dates marked in red are unavailable",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            // Syncfusion DateRangePicker with special unavailable dates
            SizedBox(
              height: height * 0.3, // Set height for the date picker
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  specialDates: unavailableDates,
                ),
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  specialDatesDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                onSelectionChanged: (args) {
                  if (args.value is DateTime) {
                    DateTime selectedDate = args.value;
                    if (unavailableDates.contains(selectedDate)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Selected date is unavailable.')),
                      );
                    } else {
                      print('Selected date: $selectedDate');
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // Booking Buttons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button to book an appointment
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _bookAppointment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.green,
                        textStyle: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Book a visit "),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Button to book the venue
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _bookVenue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.orange,
                        textStyle: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Book Venue"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Method to navigate to the booking appointment screen
  void _bookAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookAppointmentScreen()),
    );
    print('Navigate to the appointment booking screen.');
  }

  // Method to navigate to the venue booking screen
  void _bookVenue() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookBnqtScreen(
                unavailableDates: unavailableDates,
              )),
    );
    print('Navigate to the venue booking screen.');
  }
}
