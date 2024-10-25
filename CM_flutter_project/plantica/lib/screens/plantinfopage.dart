import 'dart:convert';

import 'package:flutter/material.dart';
import 'database_helper.dart';

class Plantinfopage extends StatefulWidget {
  final int plantId;

  const Plantinfopage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<Plantinfopage> createState() => _PlantinfopageState();
}

class _PlantinfopageState extends State<Plantinfopage> {
  late Future<PlantIdentification?> _plantInfoFuture;

  @override
  void initState() {
    super.initState();
    _plantInfoFuture = _fetchPlantInfo(widget.plantId);
  }

  Future<PlantIdentification?> _fetchPlantInfo(int plantId) async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getPlant(plantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PlantIdentification?>(
        future: _plantInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Plant not found'));
          }

          final plant = snapshot.data!;
          return Center(
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: NetworkImage(plant.imageUrl),
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
                  const SizedBox(height: 20),
                  Text(
                    plant.commonName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 139, 96, 133),
                    ),
                  ),
                  Text(
                    plant.scientificName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 119, 118, 118),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildInfoCard(
                          title: 'Humidity',
                          // TODO: Value com os valores do sensor
                          value: '10%',
                          info: plant.watering,
                        ),
                        const SizedBox(width: 20),
                        _buildInfoCard(
                          title: 'Temperature',
                          // TODO: Value com os valores do sensor
                          value: '10ºC',
                          info: plant.watering,
                        ),
                      ],
                    ),
                  ),
                  _buildDetailsSection(
                    title: "Description",
                    description: plant.description,
                  ),
                  _buildDetailsSection(
                    title: "About watering",
                    description: plant.bestWatering,
                  ),
                  _buildDetailsSection(
                      title: "About Lighting",
                      description: plant.bestLightCondition),
                  _buildDetailsSection(
                    title: "Soil Type",
                    description: plant.bestSoilType,
                  ),
                  if (plant.toxicity.isNotEmpty)
                    _buildDetailsSection(
                      title: "Toxicity",
                      description: plant.toxicity,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required String value, required String info}) {
    String statusInfo;
    int temp;
    int hum;
    Map<String, dynamic> infoMap = jsonDecode(info);
    int min = infoMap["min"];
    int max = infoMap["max"];

    if (title == "Humidity") {
      hum = int.parse(value.replaceAll('%', ''));
      if ((min == 1 && hum < 20) ||
          (min == 2 && hum < 40) ||
          (min == 3 && hum < 60)) {
        statusInfo = 'Dry';
      } else if ((max == 1 && hum > 40) ||
          (max == 2 && hum > 60) ||
          (max == 3 && hum > 80)) {
        statusInfo = "Wet";
      } else {
        statusInfo = "Healthy";
      }
    } else if (title == "Temperature") {
      temp = int.parse(value.replaceAll('ºC', ''));
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

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(191, 213, 187, 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
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
                    color: statusInfo == 'Healthy'
                        ? Colors.green[100]
                        : statusInfo == 'Hot'
                            ? Colors.red[300]
                            : statusInfo == 'Dry'
                                ? Colors.red[300]
                                : Colors.blue[200],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  statusInfo,
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
    );
  }

  Widget _buildDetailsSection(
      {required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 53, 53, 53),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
