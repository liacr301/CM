import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ScanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {}
class ScanOffline extends ScanState {}
class ImagePickerDisplayed extends ScanState {}
class ImageSelected extends ScanState {
  final File image;
  ImageSelected(this.image);

  @override
  List<Object?> get props => [image];
}

class Loading extends ScanState {}

class PlantIdentified extends ScanState {
  final File image;
  final String plantName;
  final int plantId;
  PlantIdentified(this.image, this.plantName, this.plantId);

  @override
  List<Object?> get props => [image, plantName, plantId];
}

class ScanError extends ScanState {
  final String message;
  ScanError(this.message);

  @override
  List<Object?> get props => [message];
}