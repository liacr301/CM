import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/profile.dart';
import 'screens/scanpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color.fromRGBO(239, 234, 216, 0.7),
      home: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            Home(),
            ScanPage(),
            Profile(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Spacer(flex: 2),
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  size: 32,
                  color: _tabIndex == 0
                      ? Colors.green.shade900
                      : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _tabIndex = 0;
                    _tabController.index = 0;
                  });
                },
              ),
              Spacer(flex: 4),
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.shade700,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.photo_camera_outlined,
                    size: 32,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _tabIndex = 1;
                      _tabController.index = 1;
                    });
                  },
                ),
              ),
              Spacer(flex: 4),
              IconButton(
                icon: Icon(
                  Icons.person_2_outlined,
                  size: 32,
                  color: _tabIndex == 2
                      ? Colors.green.shade900
                      : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _tabIndex = 2;
                    _tabController.index = 2;
                  });
                },
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
