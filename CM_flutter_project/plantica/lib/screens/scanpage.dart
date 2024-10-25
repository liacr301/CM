// Importações e definições
// TODO: ir para a main no add plant e na main chamar o plantinfopage quando carregas na planta
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'plantinfopage.dart';
import 'database_helper.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _plantName;
  int? _plantId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showImageSourceDialog();
    });
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose image source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<void> _identifyAndSavePlant(String base64Image) async {
    setState(() {
      _isLoading = true;
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

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data != null) {
          final plantInfo = PlantIdentification.fromJson(data);
          
          // Save to database and get plantId
          final dbHelper = DatabaseHelper();
          final int id = await dbHelper.insertPlant(plantInfo);
          
          setState(() {
            _plantId = id;
            _plantName = plantInfo.commonName;
          });
        }
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _plantName = 'Error identifying plant';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        String base64Image = await _imageToBase64(_image!);
        await _identifyAndSavePlant(base64Image);
      } else {
        _showImageSourceDialog();
      }
    } catch (e) {
      print('Error picking image: $e');
      _showImageSourceDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image == null)
              Text('No image selected.')
            else if (_isLoading)
              CircularProgressIndicator()
            else
              ScanPage(
                image: _image!,
                plantName: _plantName ?? 'Unknown Plant',
                plantId: _plantId,
              ),
          ],
        ),
      ),
    );
  }
}

class ScanPage extends StatelessWidget {
  final File image;
  final String plantName;
  final int? plantId;

  const ScanPage({
    required this.image,
    required this.plantName,
    required this.plantId,
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
          SizedBox(height: 20),
          Text(
            'Your plant is a',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            plantName,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 139, 96, 133),
            ),
          ),
          SizedBox(height: 20),
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Scan()),
                  );
                },
                child: Text('Try Again'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  if (plantId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Plantinfopage(plantId: plantId!),
                      ),
                    );
                  } else {
                    print('Plant ID is null');
                  }
                },
                child: Text('Add Plant'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
