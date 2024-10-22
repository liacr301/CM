import 'package:flutter/material.dart';
import 'package:plantica/const.dart';

class Plantinfopage extends StatefulWidget {
  const Plantinfopage({super.key});

  @override
  State<Plantinfopage> createState() => _Plantinfopage();
}

class _Plantinfopage extends State<Plantinfopage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
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
              ),
              ),
              SizedBox(height: 20),
              Text(
              '“Butterfly Orchid”',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 139, 96, 133)),
              ),
              Text(
              'Phalaenopsis amabilis',
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 119, 118, 118)),
              ),
              SizedBox(height: 20),
              Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Expanded(
                  child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(191, 213, 187, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                    ],
                  ),
                  child: Column(
                    children: [
                    Text(
                      'Humidity',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                          ),
                        ]),
                      child: Text(
                        '28%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                        color: myPlants[1].state == 'Healthy'
                          ? Colors.green[100]
                          : myPlants[1].state == 'Needs water'
                            ? Colors.red[300]
                            : Colors.blue[200],
                        shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        myPlants[1].state,
                        style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black,
                        fontSize: 14,
                        ),
                      ),
                      ],
                    ),
                    ],
                  ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(191, 213, 187, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                    ],
                  ),
                  child: Column(
                    children: [
                    Text(
                      'Temperature',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                        ],
                      ),
                      child: Text(
                        '35ºC',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                        color: myPlants[1].state == 'Healthy'
                          ? Colors.green[100]
                          : myPlants[1].state == 'Hot'
                            ? Colors.red[300]
                            : Colors.blue[200],
                        shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        // myPlants[1].state,
                        "It's too Hot",
                        style: const TextStyle(
                        fontFamily: 'Raleway',
                        color: Colors.black,
                        fontSize: 14,
                        ),
                      ),
                      ],
                    ),
                    ],
                  ),
                  ),
                ),
                ],
              ),
              ),
              Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                      "About watering",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    Text(
                    "Orchids need the most water during flowering, even if they otherwise would not tolerate being so wet. Water availability is critical for floral longevity. Watering should be reduced after flowering, but the plant should never be allowed to dry out completely.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 53, 53, 53),
                    ),
                    textAlign: TextAlign.left,
                    ),
                  ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                      "About Light",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    Text(
                    "Orchids need bright, indirect light. They should not be exposed to direct sunlight, as this can cause the leaves to burn. If the leaves are dark green, the plant is not receiving enough light. If the leaves are yellowish-green, the plant is receiving too much light.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 53, 53, 53),
                    ),
                    textAlign: TextAlign.left,
                    ),
                  ],
                  ),
                ),
                ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}