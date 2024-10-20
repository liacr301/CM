import 'package:flutter/material.dart';
import 'package:plantica/const.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F0E6),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F0E6),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(top: 8),
            icon: const Icon(
              Icons.settings_suggest_outlined,
              color: Color.fromRGBO(95, 113, 97, 1),
            ),
            tooltip: 'Settings',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color.fromRGBO(95, 113, 97, 1),
              ),
              tooltip: 'Notifications',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          // Wrapping multiple containers inside Column
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Container(
              height: 500,
              width: 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('$kAssetImgs/placeholder_profile_pic.jpg'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Liliana Ribeiro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '@lilikas11',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '20-12-2003',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'I there! I am a plant lover. My favourite plants are Monsteras and Lillies',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      '$kAssetImgs/monstera.png',
                      height: 160,
                      width: 160,
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
