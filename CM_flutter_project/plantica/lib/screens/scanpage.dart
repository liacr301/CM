import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async'; // Para StreamSubscription
import 'package:plantica/const.dart';
import 'plantinfopage.dart';

class Scan extends StatelessWidget {
  const Scan({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => ScanPage(), // Página principal da aba Scan
        );
      },
    );
  }
}

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isConnected = true; // Variável para monitorar o estado da conexão

  @override
  void initState() {
    super.initState();
    // Checar a conectividade inicial
    _checkConnectivity();
    // Monitorar mudanças de conectividade
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  // Verifica a conectividade inicial
  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  // Atualiza o status de conexão com base nos resultados
  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      if (result == ConnectivityResult.none) {
        _isConnected = false; // Sem conexão
      } else {
        _isConnected = true; // Conectado (Wi-Fi ou dados móveis)
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription
        .cancel(); // Cancela a assinatura quando não necessário
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Center(
          child: _isConnected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
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
                    SizedBox(height: 20),
                    Text(
                      'Your plant is a',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Orchid',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 139, 96, 133)),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300], // Cor de fundo
                            foregroundColor: Colors.black, // Cor do texto
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            _checkConnectivity(); // Rechecar a conectividade
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Plantinfopage(),
                              ),
                            );
                          },
                          child: Text('Add Plant'),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 100, color: Colors.red),
                    SizedBox(height: 20),
                    Text(
                      'No internet connection',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please check your connection and try again.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkConnectivity, // Rechecar a conexão
                      child: Text('Try Again'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
