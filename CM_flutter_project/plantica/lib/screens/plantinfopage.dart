import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantica/blocs/sensor/plantinfo_bloc.dart';
import 'package:plantica/blocs/sensor/plantinfo_event.dart';
import 'package:plantica/blocs/sensor/plantinfo_state.dart';
import '../widgets/info_card.dart';
import 'package:plantica/repositories/plant_repository.dart';
import 'package:plantica/services/sensor_service.dart';

class PlantInfoPage extends StatelessWidget {
  final int plantId;

  const PlantInfoPage({Key? key, required this.plantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantInfoBloc(
        context.read<PlantRepository>(),
        context.read<SensorService>(),
      )..add(LoadPlantInfo(plantId)),
      child: const PlantInfoView(),
    );
  }
}

class PlantInfoView extends StatelessWidget {
  const PlantInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlantInfoBloc, PlantInfoState>(
        builder: (context, state) {
          if (state is PlantInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PlantInfoError) {
            return Center(child: Text(state.message));
          }

          if (state is PlantInfoLoaded) {
            final plant = state.plant;
            final reading = state.sensorReading;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          image: DecorationImage(
                            image: NetworkImage(plant.imageUrl ?? ''),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    plant.commonName ?? '',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 139, 96, 133),
                    ),
                  ),
                  Text(
                    plant.scientificName ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 119, 118, 118),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (reading != null)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InfoCard(
                            title: 'Humidity',
                            value: '${reading.humidity.toStringAsFixed(0)}%',
                            info: plant.watering ?? '{"max":2,"min":2}',
                          ),
                          const SizedBox(width: 20),
                          InfoCard(
                            title: 'Temperature',
                            value:
                                '${reading.temperature.toStringAsFixed(0)}ºC',
                            info: plant.watering ?? '{"max":2,"min":2}',
                          ),
                        ],
                      ),
                    ),
                  _buildDetailsSection(
                    title: "Description",
                    description: plant.description ?? '',
                  ),
                  _buildDetailsSection(
                    title: "About watering",
                    description: plant.bestWatering ?? '',
                  ),
                  _buildDetailsSection(
                    title: "About Lighting",
                    description: plant.bestLightCondition ?? '',
                  ),
                  _buildDetailsSection(
                    title: "Soil Type",
                    description: plant.bestSoilType ?? '',
                  ),
                  if ((plant.toxicity ?? '').isNotEmpty)
                    _buildDetailsSection(
                      title: "Toxicity",
                      description: plant.toxicity ?? '',
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailsSection(
      {required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 139, 96, 133),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 119, 118, 118),
            ),
          ),
        ],
      ),
    );
  }
}
