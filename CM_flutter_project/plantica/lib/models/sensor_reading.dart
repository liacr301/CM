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
