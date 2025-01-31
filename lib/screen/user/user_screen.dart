import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lakebenquet/screen/userhomescreen.dart';
import 'package:lakebenquet/screen/profilescreen.dart';

class UserScreen extends StatefulWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                color: _selectedIndex == 0 ? Colors.orange : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(1),
              icon: Icon(
                Icons.photo_camera_back,
                color: _selectedIndex == 1 ? Colors.orange : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => _onItemTapped(2),
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 2 ? Colors.orange : Colors.grey,
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
          const Center(child: Text("Photos Screen")),
          ProfileScreen(user: widget.user)
        ],
      ),
    );
  }
}
