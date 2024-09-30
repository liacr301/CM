import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/search_page.dart';
import 'screens/library_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

int selectedIndex = 0;

class _MainPageState extends State<MainPage> {
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff121212),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _pages.elementAt(selectedIndex),
              Positioned(
                  bottom: 0,
                  child: Column(
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
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Row(
                          children: [
                            BottomNavBarItem(
                              title: 'Home',
                              icon: Icons.home,
                              onTap: () {
                                _onItemTapped(0);
                              },
                              index: 0,
                            ),
                            BottomNavBarItem(
                              title: 'Search',
                              icon: Icons.search,
                              onTap: () {
                                _onItemTapped(1);
                              },
                              index: 1,
                            ),
                            BottomNavBarItem(
                              title: 'Your Library',
                              icon: Icons.library_music,
                              onTap: () {
                                _onItemTapped(2);
                              },
                              index: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    Key? key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.index,
  }) : super(key: key);
  final Function()? onTap;
  final IconData icon;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        enableFeedback: false,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            // title
            Text(title,
                style: TextStyle(
                    color: selectedIndex != index
                        ? const Color(0xffababab)
                        : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Raleway",
                    fontStyle: FontStyle.normal,
                    fontSize: 11.0)),
          ],
        ),
      ),
    );
  }
}

List<Widget> _pages = <Widget>[
  const HomePage(),
  const SearchPage(),
  const LibraryPage(),
];
