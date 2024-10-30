import 'package:equatable/equatable.dart';
import 'package:plantica/models/plant_identification.dart';
import 'package:plantica/models/sensor_reading.dart';

abstract class PlantInfoState extends Equatable {
  const PlantInfoState();
  
  @override
  List<Object?> get props => [];
}

class PlantInfoInitial extends PlantInfoState {}

class PlantInfoLoading extends PlantInfoState {}

class PlantInfoLoaded extends PlantInfoState {
  final PlantIdentification plant;
  final SensorReading? sensorReading;

  const PlantInfoLoaded(this.plant, [this.sensorReading]);
  
  @override
  List<Object?> get props => [plant, sensorReading];

  PlantInfoLoaded copyWith({
    PlantIdentification? plant,
    SensorReading? sensorReading,
  }) {
    return PlantInfoLoaded(
      plant ?? this.plant,
      sensorReading ?? this.sensorReading,
    );
  }
}

class PlantInfoError extends PlantInfoState {
  final String message;

  const PlantInfoError(this.message);
  
  @override
  List<Object> get props => [message];
}
