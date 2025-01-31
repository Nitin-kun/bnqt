import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lakebenquet/screen/admin/appointmentScreen.dart';
import 'package:lakebenquet/screen/admin/editcalander.dart';
import 'package:lakebenquet/screen/userhomescreen.dart';
import 'package:lakebenquet/screen/profilescreen.dart';

class AdminScreen extends StatefulWidget {
  final User user;

  const AdminScreen({super.key, required this.user});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => _onItemTapped(0),
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: Icon(
                Icons.photo_camera_back,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: Icon(
                Icons.edit_calendar_outlined,
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(3),
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 3 ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const HomeScreen(),
          const AppointmentScreen(),
          const EditCalander(),
          ProfileScreen(user: widget.user),
        ],
      ),
    );
  }
}
