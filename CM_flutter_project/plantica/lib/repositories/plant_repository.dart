import '../database.dart';

class PlantRepository {
  final AppDatabase _database;

  PlantRepository(this._database);

  Future<PlantIdentification?> getPlant(int id) async {
    return await _database.getPlant(id);
  }
  Future<Plant?> getPlant(int id) async {
    final dbModel = await _database.getPlant(id);
    if (dbModel == null) return null;
    
    return Plant.fromDbModel(dbModel);
  }

  Future<List<Plant>> getPlants({int? userId}) async {
    final dbModels = await _database.getPlants(userId: userId);
    return dbModels.map((dbModel) => Plant.fromDbModel(dbModel)).toList();
  }

  Future<void> updateLastWatered(int plantId, DateTime dateTime) async {
    await _database.updatePlantWateringInfo(
      plantId,
      dateTime.toIso8601String(),
    );
  }
}
}