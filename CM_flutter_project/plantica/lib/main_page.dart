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
    _tabController
        .dispose(); // Dispose of the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color.fromRGBO(239, 234, 216, 0.7),
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
        bottomNavigationBar: BottomAppBar(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Spacer(
                  flex:
                      2),

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
                    _tabIndex = 0; // Muda para a aba Home
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
                  borderRadius: BorderRadius.circular(8), // Formato circular
                  color: Colors.green.shade700, // Cor do círculo
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.photo_camera_outlined,
                    size: 32, // Tamanho do ícone
                    color: Colors.white, // Cor do ícone
                  ),
                  onPressed: () {
                    setState(() {
                      _tabIndex = 1; // Muda para a aba Scan
                      _tabController.index = 1;
                    });
                  },
                ),
              ),
              Spacer(flex: 4), // Espaçador entre Scan e Profile
              // Ícone Profile no canto direito (agora centralizado)
              IconButton(
                icon: Icon(
                  Icons.person_2_outlined,
                  size: 32, // Aumenta o tamanho do ícone
                  color: _tabIndex == 2
                      ? Colors.green.shade900
                      : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _tabIndex = 2; // Muda para a aba Profile
                    _tabController.index = 2;
                  });
                },
              ),
              Spacer(
                  flex: 2), // Espaçador para mover o último ícone para o centro
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
