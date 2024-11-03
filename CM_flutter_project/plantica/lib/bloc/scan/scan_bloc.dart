import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plantica/database.dart';
import 'scan_event.dart';
import 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ImagePicker _picker = ImagePicker();
  final AppDatabase _database;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ScanBloc({required AppDatabase database}) 
      : _database = database,
        super(ScanInitial()) {
    on<InitializeScan>(_onInitializeScan);
    on<CheckConnectivity>(_onCheckConnectivity);
    on<PickImage>(_onPickImage);
    on<IdentifyPlant>(_onIdentifyPlant);
    on<ResetScan>(_onResetScan);

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((result) => add(CheckConnectivity()));
  }

  Future<void> _onInitializeScan(InitializeScan event, Emitter<ScanState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(ScanOffline());
    } else {
      emit(ImagePickerDisplayed());
    }
  }

  Future<void> _onCheckConnectivity(CheckConnectivity event, Emitter<ScanState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(ScanOffline());
    } else if (state is ScanOffline) {
      emit(ImagePickerDisplayed());
    }
  }

  Future<void> _onPickImage(PickImage event, Emitter<ScanState> emit) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: event.source);
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        emit(ImageSelected(image));
        add(IdentifyPlant(image));
      } else {
        emit(ImagePickerDisplayed());
      }
    } catch (e) {
      emit(ScanError('Error picking image: $e'));
      emit(ImagePickerDisplayed());
    }
  }

  Future<void> _onIdentifyPlant(IdentifyPlant event, Emitter<ScanState> emit) async {
    emit(Loading());
    try {
      final base64Image = base64Encode(await event.image.readAsBytes());
      
      final response = await http.post(
        Uri.parse('https://plant.id/api/v3/identification?details=common_names,url,description,taxonomy,inaturalist_id,edible_parts,watering,propagation_methods,best_watering,best_light_condition,best_soil_type,toxicity&language=en'),
        headers: {
          'Api-Key': 'YHqKzBTy3AVgmIEc76xyUC7nwgUiQLfrkPtIyL46lZxQzK96qu',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'images': ['data:image/jpg;base64,$base64Image']
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data != null) {
          final plantInfo = PlantIdentification.fromJson(data);
          final int id = await _database.insertPlant(plantInfo);
          
          if (id > 0) {
            emit(PlantIdentified(event.image, plantInfo.commonName ?? 'Unknown Plant', id));
          } else {
            emit(ScanError('Error saving plant to database'));
          }
        }
      } else {
        emit(ScanError('Failed to identify plant: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ScanError('Error in plant identification: $e'));
    }
  }

  void _onResetScan(ResetScan event, Emitter<ScanState> emit) {
    emit(ImagePickerDisplayed());
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}