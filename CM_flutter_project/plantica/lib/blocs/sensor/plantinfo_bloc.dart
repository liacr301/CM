import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantica/repositories/plant_repository.dart';
import 'package:plantica/services/sensor_service.dart';
import 'package:plantica/blocs/sensor/plantinfo_event.dart';
import 'package:plantica/blocs/sensor/plantinfo_state.dart';

class PlantInfoBloc extends Bloc<PlantInfoEvent, PlantInfoState> {
  final PlantRepository _plantRepository;
  final SensorService _sensorService;
  StreamSubscription? _sensorSubscription;

  PlantInfoBloc(this._plantRepository, this._sensorService)
      : super(PlantInfoInitial()) {
    on<LoadPlantInfo>(_onLoadPlantInfo);
    on<UpdateSensorReading>(_onUpdateSensorReading);
  }

  Future<void> _onLoadPlantInfo(
    LoadPlantInfo event,
    Emitter<PlantInfoState> emit,
  ) async {
    emit(PlantInfoLoading());
    try {
      final plant = await _plantRepository.getPlant(event.plantId);
      if (plant == null) {
        emit(const PlantInfoError('Plant not found'));
        return;
      }

      await _sensorService.initialize();
      _sensorSubscription?.cancel();
      _sensorSubscription = _sensorService.readingsStream.listen(
        (reading) => add(UpdateSensorReading(reading)),
      );

      emit(PlantInfoLoaded(plant));
    } catch (e) {
      emit(PlantInfoError(e.toString()));
    }
  }

  void _onUpdateSensorReading(
    UpdateSensorReading event,
    Emitter<PlantInfoState> emit,
  ) {
    if (state is PlantInfoLoaded) {
      final currentState = state as PlantInfoLoaded;
      emit(currentState.copyWith(sensorReading: event.reading));
    }
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    _sensorService.dispose();
    return super.close();
  }
}