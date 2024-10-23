import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'plantinfopage.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _plantName;
  String? _accessToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback para garantir que o widget está montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showImageSourceDialog();
    });
  }

  // Diálogo para escolher entre câmera e galeria
  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar o diálogo clicando fora
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

  // Função para converter imagem em base64
  Future<String> _imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  // Função para fazer a requisição à API
  Future<void> _identifyPlant(String base64Image) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://plant.id/api/v3/identification?details=common_names'),
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
          print(data.toString());
        } else {
          print('No data received from API');
        }

        setState(() {
          _accessToken = data['access_token'];
          // Pegando o primeiro common name disponível da nova estrutura
          if (data['result'] != null &&
              data['result']['classification']['suggestions'].isNotEmpty &&
              data['result']['classification']['suggestions'][0]['details']
                      ['common_names'] !=
                  null &&
              data['result']['classification']['suggestions'][0]['details']
                      ['common_names']
                  .isNotEmpty) {
            _plantName = data['result']['classification']['suggestions'][0]
                ['details']['common_names'][0];
          } else {
            _plantName = 'Unknown Plant';
          }
        });
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

  // Função para capturar a imagem
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // Converter imagem para base64 e fazer a requisição
        String base64Image = await _imageToBase64(_image!);
        await _identifyPlant(base64Image);
      } else {
        // Se nenhuma imagem foi selecionada, mostra o diálogo novamente
        _showImageSourceDialog();
      }
    } catch (e) {
      print('Error picking image: $e');
      // Em caso de erro, mostra o diálogo novamente
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
                  image: _image!, plantName: _plantName ?? 'Unknown Plant', accessToken: _accessToken ?? ''),
          ],
        ),
      ),
    );
  }
}



class ScanPage extends StatelessWidget {
  final File image;
  final String plantName;
  final String accessToken;

  const ScanPage({
    required this.image,
    required this.plantName,
    required this.accessToken,
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
                  if (accessToken != '') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Plantinfopage(accessToken: accessToken!),
                      ),
                    );
                  } else {
                    print('Access token is null');
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
