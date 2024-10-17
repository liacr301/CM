import 'package:flutter/material.dart';
import 'package:plantica/const.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 250, 233),
        title: Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            'Your Plants...',
            style: GoogleFonts.instrumentSerif(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(95, 113, 97, 1),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(top: 8),
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
            padding: EdgeInsets.only(top: 8, right: 8),
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
      body: myPlants.isEmpty ? HomeWithoutPlants() : PlantList(),
      backgroundColor: const Color.fromARGB(255, 255, 250, 233),
    );
  }
}

class PlantList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: myPlants.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      image: DecorationImage(
                        image: NetworkImage(myPlants[index].img),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          myPlants[index].name,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: Color.fromARGB(255, 24, 48, 3),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          myPlants[index].scientificName,
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            color: Color.fromARGB(255, 24, 48, 3),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: myPlants[index].state == 'Healthy'
                                    ? Colors.green[100]
                                    : myPlants[index].state == 'Needs water'
                                        ? Colors.red[300]
                                        : Colors.blue[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                myPlants[index].state,
                                style: const TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), 
            ],
          );
        },
      ),
    );
  }
}

class HomeWithoutPlants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            '$kAssetImgs/plant.png',
            height: 220,
            width: 220,
          ),
          const SizedBox(height: 8),
          Text(
            'Ups!',
              style: GoogleFonts.instrumentSerif(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'It seems like you don\'t own any plants yet',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          Material(
            shape: const CircleBorder(),
            color: Colors.green.shade700,
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
