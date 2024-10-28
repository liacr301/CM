import 'dart:math';
import 'dart:async';
import '../models/sensor_reading.dart';

class SensorService {
  final double _baseTemperature = 22.0; // temperatura média ambiente
  final double _baseHumidity = 55.0;    // humidade média ambiente
  final List<SensorReading> _historicalReadings = [];
  final StreamController<SensorReading> _sensorReadingController = StreamController<SensorReading>.broadcast();
  Timer? _timer; // Define o timer como uma variável membro da classe

  SensorService() {
    _generateInitialHistory();
  }

  void _generateInitialHistory() {
    final now = DateTime.now();
    for (int i = 0; i < 24; i++) {
      final timestamp = now.subtract(Duration(hours: i));
      _historicalReadings.add(_generateReading(timestamp));
    }
  }

  SensorReading _generateReading(DateTime timestamp) {
    final tempVariation = (sin((timestamp.hour - 4) * pi / 10) * 2.0);
    final humidityVariation = (-sin((timestamp.hour - 4) * pi / 10) * 5.0);

    final tempNoise = (Random().nextDouble() - 0.5) * 0.5;
    final humidityNoise = (Random().nextDouble() - 0.5) * 2.0;

    double temperature = _baseTemperature + tempVariation + tempNoise;
    double humidity = _baseHumidity + humidityVariation + humidityNoise;

    humidity = humidity.clamp(0.0, 100.0);

    return SensorReading(
      timestamp: timestamp,
      temperature: double.parse(temperature.toStringAsFixed(1)),
      humidity: double.parse(humidity.toStringAsFixed(1)),
    );
  }

  Future<List<SensorReading>> fetchReadings() async {
    await Future.delayed(Duration(seconds: 1));
    return List.unmodifiable(_historicalReadings);
  }

  void initialize() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      final newReading = _generateReading(DateTime.now());
      _sensorReadingController.add(newReading); // Adiciona nova leitura ao stream
    });
  }

  void dispose() {
    _timer?.cancel(); 
    _sensorReadingController.close(); 
  }

  Stream<SensorReading> get sensorReadings => _sensorReadingController.stream;
}
