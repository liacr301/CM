import 'dart:async';
import 'dart:math' as math;

class SensorReading {
  final DateTime timestamp;
  final double temperature;
  final double humidity;

  SensorReading({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
  });
}

class SensorService {
  // Stream controller para emitir novas leituras
  final _readingsController = StreamController<SensorReading>.broadcast();
  Timer? _timer;
  
  // Lista para manter histórico de leituras
  final List<SensorReading> _historicalReadings = [];
  
  // Valores base para ambiente interno
  final double _baseTemperature = 22.0; // temperatura média ambiente
  final double _baseHumidity = 55.0;    // humidade média ambiente
  
  // Getters
  Stream<SensorReading> get readingsStream => _readingsController.stream;
  List<SensorReading> get historicalReadings => List.unmodifiable(_historicalReadings);

  Future<void> initialize() async {
    // Gera primeiras leituras históricas
    _generateInitialHistory();
    
    // Inicia atualizações periódicas
    startRealTimeUpdates();
  }

  void startRealTimeUpdates() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final reading = _generateReading();
      _addReading(reading);
    });
  }

  void _generateInitialHistory() {
    // Gera últimas 24 horas de dados
    final now = DateTime.now();
    for (int i = 24; i >= 0; i--) {
      final timestamp = now.subtract(Duration(hours: i));
      final reading = _generateHistoricalReading(timestamp);
      _historicalReadings.add(reading);
    }
  }

  SensorReading _generateReading() {
    return _generateHistoricalReading(DateTime.now());
  }

  SensorReading _generateHistoricalReading(DateTime timestamp) {
    final hour = timestamp.hour;
    
    // Variação diária de temperatura (pico às 14h, mínimo às 4h)
    final tempVariation = math.sin((hour - 4) * math.pi / 10) * 2.0;
    
    // Humidade varia inversamente à temperatura
    final humidityVariation = -math.sin((hour - 4) * math.pi / 10) * 5.0;
    
    // Adiciona pequena variação aleatória
    final tempNoise = (math.Random().nextDouble() - 0.5) * 0.5;
    final humidityNoise = (math.Random().nextDouble() - 0.5) * 2.0;
    
    // Calcula valores finais
    double temperature = _baseTemperature + tempVariation + tempNoise;
    double humidity = _baseHumidity + humidityVariation + humidityNoise;
    
    // Garante que a humidade está entre 0-100%
    humidity = humidity.clamp(0.0, 100.0);
    
    // Arredonda para uma casa decimal
    temperature = double.parse(temperature.toStringAsFixed(1));
    humidity = double.parse(humidity.toStringAsFixed(1));
    
    return SensorReading(
      timestamp: timestamp,
      temperature: temperature,
      humidity: humidity,
    );
  }

  void _addReading(SensorReading reading) {
    _historicalReadings.add(reading);
    
    // Mantém apenas últimas 24 horas de dados
    while (_historicalReadings.length > 288) { // 24h * 12 leituras por hora
      _historicalReadings.removeAt(0);
    }
    
    _readingsController.add(reading);
  }

  // Métodos para análise de dados
  double getAverageTemperature([int minutes = 60]) {
    return _getAverage(minutes, (reading) => reading.temperature);
  }

  double getAverageHumidity([int minutes = 60]) {
    return _getAverage(minutes, (reading) => reading.humidity);
  }

  double _getAverage(int minutes, num Function(SensorReading) selector) {
    final now = DateTime.now();
    final readings = _historicalReadings.where((reading) =>
        reading.timestamp.isAfter(now.subtract(Duration(minutes: minutes))));
    
    if (readings.isEmpty) return 0.0;
    
    final sum = readings.map(selector).reduce((a, b) => a + b);
    return double.parse((sum / readings.length).toStringAsFixed(1));
  }

  // Métodos para verificar condições
  bool isTemperatureInRange(double minTemp, double maxTemp) {
    final currentTemp = _historicalReadings.last.temperature;
    return currentTemp >= minTemp && currentTemp <= maxTemp;
  }

  bool isHumidityInRange(double minHumidity, double maxHumidity) {
    final currentHumidity = _historicalReadings.last.humidity;
    return currentHumidity >= minHumidity && currentHumidity <= maxHumidity;
  }

  void dispose() {
    _timer?.cancel();
    _readingsController.close();
  }
}
