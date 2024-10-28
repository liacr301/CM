import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'plantinfopage.dart';
import 'package:plantica/database.dart';

class Scan extends StatelessWidget {
  const Scan({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: const ValueKey<String>('scan_navigator'),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ScanMainPage(),
        );
      },
    );
  }
}

class ScanMainPage extends StatefulWidget {
  const ScanMainPage({super.key});

  @override
  State<ScanMainPage> createState() => _ScanMainPageState();
}

class _ScanMainPageState extends State<ScanMainPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _plantName;
  int? _plantId;
  bool _isLoading = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (mounted) {
        _updateConnectionStatus(result);
        if (result != ConnectivityResult.none && !_isDialogShowing && _image == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showImageSourceDialog();
          });
        }
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isConnected && !_isDialogShowing && _image == null) {
        _showImageSourceDialog();
      }
    });
  }

  void _resetState() {
    setState(() {
      _image = null;
      _plantName = null;
      _plantId = null;
      _isLoading = false;
    });
  }

  Future<void> _checkConnectivity() async {
    if (!mounted) return;
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    if (!mounted) return;
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    if (!mounted || !_isConnected || _isDialogShowing) {
      return;
    }

    setState(() {
      _isDialogShowing = true;
    });

    if (!mounted) return;

    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text('Choose image source'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Camera'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDialogShowing = false;
        });
      }
    }
  }

  Future<String> _imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  
  Future<void> _identifyAndSavePlant(String base64Image) async {
    if (!mounted || !_isConnected) {
      return;
    }

    setState(() {
      _isLoading = true;
      _plantId = null;  // Reset plant ID
      _plantName = null;  // Reset plant name
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://plant.id/api/v3/identification?details=common_names,url,description,taxonomy,inaturalist_id,edible_parts,watering,propagation_methods,best_watering,best_light_condition,best_soil_type,toxicity&language=en'),
        headers: {
          'Api-Key': 'KYRgRxXJyjuviR4rUORZ5sKej8zsaE5ixyPOqIUXP0cQWhpkc8',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'images': ['data:image/jpg;base64,$base64Image']
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data != null) {
          final plantInfo = PlantIdentification.fromJson(data);

          final dbHelper = AppDatabase();
          try {
            final int id = await dbHelper.insertPlant(plantInfo);
            
            if (!mounted) return;
            
            if (id > 0) {  // Verifica se o ID é válido
              setState(() {
                _plantId = id;
                _plantName = plantInfo.commonName;
              });
            } else {
              throw Exception('Invalid plant ID received from database');
            }
          } catch (dbError) {
            print('Database error: $dbError');
            setState(() {
              _plantName = 'Error saving plant';
              _plantId = null;
            });
          }
        }
      } else {
        throw Exception('Failed to identify plant: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in plant identification: $e');
      if (mounted) {
        setState(() {
          _plantName = 'Error identifying plant';
          _plantId = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

    Future<void> _pickImage(ImageSource source) async {
    if (!mounted) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (!mounted) return;

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        String base64Image = await _imageToBase64(_image!);
        await _identifyAndSavePlant(base64Image);
      } else if (mounted) {
        _showImageSourceDialog();
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        _showImageSourceDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: _isConnected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_image == null)
                          const Text('No image selected.')
                        else if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          ScanResultPage(
                            image: _image!,
                            plantName: _plantName ?? 'Unknown Plant',
                            plantId: _plantId,
                            onTryAgain: () {
                              _resetState();
                              _showImageSourceDialog();
                            },
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 100, color: Colors.red),
                        const SizedBox(height: 20),
                        const Text(
                          'No internet connection',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Please check your connection and try again.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _checkConnectivity,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScanResultPage extends StatelessWidget {
  final File image;
  final String plantName;
  final int? plantId;
  final VoidCallback onTryAgain;

  const ScanResultPage({
    required this.image,
    required this.plantName,
    required this.plantId,
    required this.onTryAgain,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              image: DecorationImage(
                image: FileImage(image),
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
          const SizedBox(height: 20),
          const Text(
            'Your plant is a',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            plantName,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 139, 96, 133),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: onTryAgain,
                child: const Text('Try Again'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: plantId == null || plantId! <= 0
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Plantinfopage(
                              plantId: plantId!,
                            ),
                          ),
                        );
                      },
                child: const Text('Add Plant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}