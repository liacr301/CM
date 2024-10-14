import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/profile.dart';
import 'screens/scanpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0; // Variable to store current tab index

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 3 tabs (one for each screen)
    _tabController = TabController(length: 3, vsync: this);

    // Add a listener to update the BottomNavigationBar's selected index when swiping
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index; // Sync the tab index when swiping
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        body: TabBarView(
          // Allow swiping between tabs
          controller: _tabController,
          children: [
            Home(),
            Scan(),
            Profile(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green.shade900,
          unselectedItemColor: Colors.grey.shade600, // Changed for more clarity
          backgroundColor: Colors.white,
          currentIndex: _tabIndex, // Sync with the tab controller
          onTap: (int index) {
            setState(() {
              _tabIndex = index; // Change tab on tap
              _tabController.index = index; // Update the TabController
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera_outlined),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
