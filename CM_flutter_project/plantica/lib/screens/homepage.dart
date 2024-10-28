import 'package:flutter/material.dart';
import 'package:plantica/const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plantica/database.dart';
import 'package:plantica/sensor_service.dart';
import 'plantinfopage.dart';
import 'dart:convert';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
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
      backgroundColor: Color(0xFFF3F4F6),
    );
  }
}

class PlantList extends StatefulWidget {
  @override
  _PlantListState createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  late List<Map<String, dynamic>> _plants = [];
  late SensorService _sensorService;

  @override
  void initState() {
    super.initState();
    _fetchPlantsFromDatabase();
    _sensorService = SensorService();
    _sensorService.initialize();
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  Future<void> _fetchPlantsFromDatabase() async {
    final dbHelper = AppDatabase();
    _plants = await dbHelper.getAllPlants();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _plants.length,
        itemBuilder: (BuildContext context, int index) {
          final plant = _plants[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Plantinfopage(plantId: plant['id']),
                ),
              );
            },
            child: Column(
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
                          image: NetworkImage(plant['image_url']),
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
                            plant['common_name'],
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              color: Color.fromARGB(255, 24, 48, 3),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            plant['scientific_name'],
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              color: Color.fromARGB(255, 24, 48, 3),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // Buscar dados do sensor e dar estado
                          StreamBuilder<SensorReading>(
                            stream: _sensorService.readingsStream,
                            builder: (context, sensorSnapshot) {
                              String humidityValue = '0%';
                              String temperatureValue = '0ºC';

                              if (sensorSnapshot.hasData) {
                                humidityValue =
                                    '${sensorSnapshot.data!.humidity.toStringAsFixed(0)}%';
                                temperatureValue =
                                    '${sensorSnapshot.data!.temperature.toStringAsFixed(0)}ºC';
                              }

                              String statusInfo = getPlantStatus(
                                title: 'Humidity',
                                value: humidityValue,
                                info: plant['humidity_info']??
                                  '{"max":2,"min":2}',
                              );

                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: statusInfo == 'Healthy'
                                      ? Colors.green[100]
                                      : statusInfo == 'Needs Water'
                                          ? Colors.red[300]
                                          : Colors.blue[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  statusInfo,
                                  style: const TextStyle(
                                    fontFamily: 'Raleway',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
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

String getPlantStatus(
    {required String title, required String value, required String info}) {
  String statusInfo;
  int temp;
  int hum;
  Map<String, dynamic> infoMap;

  try {
    infoMap = jsonDecode(info);
  } catch (e) {
    infoMap = {"max": 2, "min": 2};
  }

  int min = infoMap["min"] ?? 2;
  int max = infoMap["max"] ?? 2;

  if (title == "Humidity") {
    try {
      hum = int.parse(value.replaceAll('%', ''));
    } catch (e) {
      hum = 0;
    }

    if ((min == 1 && hum < 20) ||
        (min == 2 && hum < 40) ||
        (min == 3 && hum < 60)) {
      statusInfo = 'Needs Water';
    } else if ((max == 1 && hum > 40) ||
        (max == 2 && hum > 60) ||
        (max == 3 && hum > 80)) {
      statusInfo = "Too much water";
    } else {
      statusInfo = "Healthy";
    }
  } else if (title == "Temperature") {
    try {
      temp = int.parse(value.replaceAll('ºC', ''));
    } catch (e) {
      temp = 0;
    }

    if ((min == 1 && temp < 18) ||
        (min == 2 && temp < 16) ||
        (min == 3 && temp < 18)) {
      statusInfo = 'Cold';
    } else if ((max == 1 && temp > 30) ||
        (max == 2 && temp > 28) ||
        (max == 3 && temp > 26)) {
      statusInfo = "Hot";
    } else {
      statusInfo = "Healthy";
    }
  } else {
    statusInfo = "";
    throw ArgumentError('Invalid title: $title');
  }

  return statusInfo;
}
