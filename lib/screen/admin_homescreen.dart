
 import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
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
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
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
        children: const [
          Center(child: Text("Home Screen")),
          Center(child: Text("Photos Screen")),
          Center(child: Text("Profile Screen")),
        ],
      ),
    );
  }
}
