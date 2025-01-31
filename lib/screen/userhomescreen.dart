import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lakebenquet/screen/user/bookappointment.dart';
import 'package:lakebenquet/screen/user/bookBnqtScreen.dart';
import 'package:lakebenquet/widgets/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';


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

  List<DateTime> unavailableDates = [];

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

  Future<void> _makecall() async {
    final Uri url = Uri.parse("tel:+918521188010");
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      throw 'could not make the call $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child:
                IconButton(onPressed: _makecall, icon: const Icon(Icons.call)),
          )
        ],
        title: const Text(
          'Welcome to Lake Garden Banquet',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUnavailableDates,
        child: ListView(
          children: [
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Lake Garden Banquet Hall is a spacious venue for your special events. "
                "We offer a beautifully designed hall and green lawn to make your gatherings memorable.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "   Dates marked in red are unavailable",
                style: TextStyle(
                  
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            // TableCalendar Implementation
            TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                headerPadding: EdgeInsets.zero,
                leftChevronIcon: Icon(Icons.chevron_left, size: width * 0.06),
                rightChevronIcon: Icon(Icons.chevron_right, size: width * 0.06),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  //color: const Color.fromARGB(136, 236, 215, 215),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(fontSize: width * 0.035),
                weekendTextStyle: TextStyle(fontSize: width * 0.035),
                selectedTextStyle: TextStyle(fontSize: width * 0.035),
                todayTextStyle: TextStyle(fontSize: width * 0.035),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool isUnavailable = unavailableDates.any(
                    (unavailableDay) =>
                        unavailableDay.year == day.year &&
                        unavailableDay.month == day.month &&
                        unavailableDay.day == day.day);
                  return Container(
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isUnavailable ? Colors.red : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isUnavailable ? Colors.white : Colors.black,
                        fontSize: width * 0.035,
                      ),
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (unavailableDates.contains(selectedDay)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Selected date is unavailable.')),
                  );
                } else {
                  print('Selected date: $selectedDay');
                }
              },
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: BnqtButton(text: "Book vist", onPressed: _bookAppointment)
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: BnqtButton(
                    onPressed: _bookVenue,
                    text: "Book venue",
                    backgroundColor: Colors.green,
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _bookAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookAppointmentScreen()),
    );
  }

  void _bookVenue() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BookBnqtScreen(
                unavailableDates: unavailableDates,
              )),
    );
  }
}