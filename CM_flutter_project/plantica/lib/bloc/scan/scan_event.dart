import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

abstract class ScanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeScan extends ScanEvent {}

class CheckConnectivity extends ScanEvent {}

class PickImage extends ScanEvent {
  final ImageSource source;
  PickImage(this.source);

  @override
  List<Object?> get props => [source];
}

class IdentifyPlant extends ScanEvent {
  final File image;
  IdentifyPlant(this.image);

  @override
  List<Object?> get props => [image];
}

class ResetScan extends ScanEvent {}