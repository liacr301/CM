import 'package:flutter/material.dart';
import 'dart:convert';

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String info;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.info,
  }) : super(key: key);

  String _getStatusInfo() {
    String statusInfo;
    Map<String, dynamic> infoMap;

    try {
      infoMap = jsonDecode(info);
    } catch (e) {
      infoMap = {"max": 2, "min": 2};
    }

    int min = infoMap["min"] ?? 2;
    int max = infoMap["max"] ?? 2;

    if (title == "Humidity") {
      int hum = int.tryParse(value.replaceAll('%', '')) ?? 0;

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
      int temp = int.tryParse(value.replaceAll('ºC', '')) ?? 0;

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
      throw ArgumentError('Invalid title: $title');
    }

    return statusInfo;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Healthy':
        return Colors.green[100]!;
      case 'Hot':
      case 'Dry':
        return Colors.red[300]!;
      default:
        return Colors.blue[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();

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
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                    color: _getStatusColor(statusInfo),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
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
}