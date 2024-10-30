import 'package:equatable/equatable.dart';
import 'package:plantica/models/sensor_reading.dart';

abstract class PlantInfoEvent extends Equatable {
  const PlantInfoEvent();

  @override
  List<Object?> get props => [];
}

class LoadPlantInfo extends PlantInfoEvent {
  final int plantId;

  const LoadPlantInfo(this.plantId);

  @override
  List<Object> get props => [plantId];
}

class UpdateSensorReading extends PlantInfoEvent {
  final SensorReading reading;

  const UpdateSensorReading(this.reading);

  @override
  List<Object> get props => [reading];
}