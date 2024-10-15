import 'package:flutter/material.dart';
import 'package:plantica/const.dart';
import 'plantinfopage.dart';


class Plantinfopage extends StatefulWidget {
  const Plantinfopage({super.key});

  @override
  State<Plantinfopage> createState() => _Plantinfopage();
}

class _Plantinfopage extends State<Plantinfopage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
                image: DecorationImage(
                  image: NetworkImage(myPlants[1].img),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your plant is a',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Lily',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 139, 96, 133)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red[300], // Change the background color here
                    foregroundColor: Colors.black, // Change the text color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the border radius here
                    ),
                  ),
                  onPressed: () {
                    // Add logic for "Try Again" button
                  },
                  child: Text('Try Again'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green[100], // Change the background color here
                    foregroundColor: Colors.black, // Change the text color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the border radius here
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Plantinfopage(),
                      ),
                    );
                  },
                  child: Text('Add '),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
