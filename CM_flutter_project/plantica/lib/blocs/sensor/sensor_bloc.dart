import 'package:flutter_bloc/flutter_bloc.dart';
import 'sensor_event.dart';
import 'sensor_state.dart';
import 'package:plantica/models/sensor_reading.dart';
import 'package:plantica/services/sensor_service.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  final SensorService sensorService;

  SensorBloc(this.sensorService) : super(SensorInitial());

  Stream<SensorState> mapEventToState(SensorEvent event) async* {
    if (event is FetchSensorDataEvent) {
      yield SensorLoading();
      try {
        final List<SensorReading> readings = await sensorService.fetchReadings();
        yield SensorDataLoaded(readings);
      } catch (e) {
        yield SensorError(e.toString());
      }
    }
  }
}
