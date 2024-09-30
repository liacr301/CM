import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/search_page.dart';
import 'screens/library_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with the number of pages
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // This shows the content of the tabs
            TabBarView(
              controller: _tabController,
              children: const [
                HomePage(),
                SearchPage(),
                LibraryPage(),
              ],
            ),
            // Positioned at the bottom
            Positioned(
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 0, 0, 0),
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(135, 0, 0, 0),
                          Color.fromARGB(80, 0, 0, 0),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.0, 0.3, 0.6, 0.75, 1.0],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white, // Selected tab color
                        unselectedLabelColor: const Color(0xffababab), // Unselected tab color
                        indicatorColor: Colors.transparent, // Remove the default underline
                        labelStyle: const TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0,
                        ),
                        tabs: const [
                          Tab(
                            text: 'Home',
                            icon: Icon(Icons.home),
                          ),
                          Tab(
                            text: 'Search',
                            icon: Icon(Icons.search),
                          ),
                          Tab(
                            text: 'Your Library',
                            icon: Icon(Icons.library_music),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
