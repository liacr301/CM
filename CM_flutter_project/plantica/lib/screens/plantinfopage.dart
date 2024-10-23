import 'package:flutter/material.dart';
import 'package:plantica/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Plantinfopage extends StatefulWidget {
  final String accessToken;

  const Plantinfopage({
    required this.accessToken,
    Key? key
  }) : super(key: key);

  @override
  State<Plantinfopage> createState() => _Plantinfopage();
}

class _Plantinfopage extends State<Plantinfopage> {
  Map<String, dynamic>? plantData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPlantData();
  }

  Future<void> fetchPlantData() async {
    try {
      final response = await http.get(
        Uri.parse('https://plant.id/api/v3/identification/${widget.accessToken}?details=common_names,url,image,description,taxonomy,edible_parts,watering,propagation_methods,best_watering,best_light_condition,best_soil_type,toxicity&language=en'),
        headers: {
          'Api-Key': 'KYRgRxXJyjuviR4rUORZ5sKej8zsaE5ixyPOqIUXP0cQWhpkc8',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          plantData = json.decode(response.body);
          isLoading = false;
        });
        print('API Response: ${response.body}'); // Debug print
      } else {
        setState(() {
          error = 'Failed to load plant data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching plant data: $e';
        isLoading = false;
      });
      print('Error: $e'); // Debug print
    }
  }

  Widget _buildInfoSection(String title, String? content) {
    if (content == null || content.isEmpty) return Container();
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 53, 53, 53),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color.fromRGBO(191, 213, 187, 1),
          ),
          SizedBox(height: 16),
          Text('Loading plant information...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              error ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  error = null;
                });
                fetchPlantData();
              },
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  String? _getCommonName() {
    try {
      final suggestions = plantData?['result']['classification']['suggestions'] as List?;
      if (suggestions == null || suggestions.isEmpty) return null;
      
      final details = suggestions[0]['details'] as Map<String, dynamic>?;
      if (details == null) return null;
      
      final commonNames = details['common_names'] as List?;
      return commonNames?.isNotEmpty == true ? commonNames![0].toString() : null;
    } catch (e) {
      print('Error getting common name: $e');
      return null;
    }
  }


  String? _getImage() {
    try {
      final suggestions = plantData?['result']['classification']['suggestions'] as List?;
      if (suggestions == null || suggestions.isEmpty) return null;
      
      final details = suggestions[0]['details'] as Map<String, dynamic>?;
      if (details == null) return null;
      
      final commonNames = details['common_names'] as List?;
      return commonNames?.isNotEmpty == true ? commonNames![0].toString() : null;
    } catch (e) {
      print('Error getting common name: $e');
      return null;
    }
  }

  String? _getScientificName() {
    try {
      final suggestions = plantData?['result']['classification']['suggestions'] as List?;
      return suggestions?.isNotEmpty == true ? suggestions![0]['name']?.toString() : null;
    } catch (e) {
      print('Error getting scientific name: $e');
      return null;
    }
  }

  String? _getDescription() {
    try {
      final suggestions = plantData?['result']['classification']['suggestions'] as List?;
      if (suggestions == null || suggestions.isEmpty) return null;
      
      final details = suggestions[0]['details'] as Map<String, dynamic>?;
      if (details == null) return null;
      
      return details['description']?['value']?.toString();
    } catch (e) {
      print('Error getting description: $e');
      return null;
    }
  }

  Widget _buildContent() {
    final commonName = _getCommonName() ?? 'Unknown Plant';
    final scientificName = _getScientificName() ?? 'Species unknown';
    final description = _getDescription();

    return SingleChildScrollView(
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
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(
                    image: AssetImage('assets/default_plant.png'), // Use a default image
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
            '"$commonName"',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 139, 96, 133),
            ),
          ),
          Text(
            scientificName,
            style: TextStyle(
              fontSize: 20,
              color: const Color.fromARGB(255, 119, 118, 118),
            ),
          ),
          SizedBox(height: 20),
          // Mantendo os widgets de temperatura e umidade
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                              '28%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
                                color: Colors.green[100],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Healthy',
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                                fontWeight: FontWeight.bold,
                              ),
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
                                color: Colors.red[300],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
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
                if (description != null)
                  _buildInfoSection("Description", description),
                _buildInfoSection(
                  "About Watering",
                  plantData?['result']?['classification']?['suggestions']?[0]?['details']?['best_watering'] ?? 
                  "Water regularly but do not overwater. Keep the soil moist but not waterlogged.",
                ),
                _buildInfoSection(
                  "About Light",
                  plantData?['result']?['classification']?['suggestions']?[0]?['details']?['best_light_condition'] ??
                  "Prefers bright, indirect light. Avoid direct sunlight.",
                ),
                _buildInfoSection(
                  "Soil Requirements",
                  plantData?['result']?['classification']?['suggestions']?[0]?['details']?['best_soil_type'] ??
                  "Use well-draining soil mix specifically designed for orchids.",
                ),
                _buildInfoSection(
                  "Toxicity",
                  plantData?['result']?['classification']?['suggestions']?[0]?['details']?['toxicity'] ??
                  "This plant is generally considered non-toxic.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? _buildLoadingState()
          : error != null
              ? _buildErrorState()
              : _buildContent(),
    );
  }
}