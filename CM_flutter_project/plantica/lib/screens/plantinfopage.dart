import 'package:flutter/material.dart';
import 'package:plantica/switchbot_helper.dart';

class Plantinfopage extends StatefulWidget {
  const Plantinfopage({super.key});

  @override
  State<Plantinfopage> createState() => _Plantinfopage();
}

class _Plantinfopage extends State<Plantinfopage> {
  final String deviceId = '0403-D93431304A87'; // ID do dispositivo SwitchBot
  final SwitchBotService _switchBotService = SwitchBotService(
    token: '97e2129d5b86d55f2a7aedea4367d43a1f2451337be9861f3c737d6c1549d6e6c87fd8a3346e1f6aa200cbb32a55bc60',
    secret: '79ccf740b87f74b72a9c2700ee8b5cfb',
  );

  double? humidity;
  double? temperature;
  String state = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await _switchBotService.fetchSensorData(deviceId);
      setState(() {
        temperature = data['temperature'];
        humidity = data['humidity'];
        state = _getPlantState(temperature!, humidity!);
      });
    } catch (error) {
      setState(() {
        state = 'Error fetching data';
      });
      print('Error: $error');
    }
  }

  String _getPlantState(double temp, double hum) {
    if (temp > 35) return "It's too hot";
    if (hum < 30) return "Needs water";
    return "Healthy";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display plant image
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://example.com/path/to/plant_image.jpg'), // Replace with your actual image URL
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
              const SizedBox(height: 20),
              const Text(
                '“Butterfly Orchid”',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 139, 96, 133),
                ),
              ),
              const Text(
                'Phalaenopsis amabilis',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 119, 118, 118),
                ),
              ),
              const SizedBox(height: 20),

              // Display humidity and temperature
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Humidity section
                    Expanded(
                      child: _buildInfoContainer(
                        'Humidity',
                        '${humidity?.toStringAsFixed(1) ?? 'Loading'}%',
                        humidity ?? 0,
                        state == 'Needs water' ? Colors.red[300] : Colors.green[100],
                        state,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Temperature section
                    Expanded(
                      child: _buildInfoContainer(
                        'Temperature',
                        '${temperature?.toStringAsFixed(1) ?? 'Loading'}°C',
                        temperature ?? 0,
                        state == 'It\'s too hot' ? Colors.red[300] : Colors.green[100],
                        state,
                      ),
                    ),
                  ],
                ),
              ),
              // Add additional plant info sections as required
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String title, String value, double metric, Color? color, String state) {
    return Container(
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                state,
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
    );
  }
}
