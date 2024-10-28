import 'package:plantica/models/sensor_reading.dart';

abstract class SensorState {}

class SensorInitial extends SensorState {}

class SensorLoading extends SensorState {}

class SensorDataLoaded extends SensorState {
  final List<SensorReading> readings;

  SensorDataLoaded(this.readings);
}

class SensorError extends SensorState {
  final String message;

  SensorError(this.message);
}