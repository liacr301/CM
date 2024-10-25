import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class PlantIdentification {
  final int? id;
  final String accessToken;
  final String commonName;
  final String imageUrl;
  final String scientificName;
  final String description;
  final String watering;
  final String bestWatering;
  final String bestLightCondition;
  final String bestSoilType;
  final String toxicity;

  PlantIdentification({
    this.id,
    required this.accessToken,
    required this.commonName,
    required this.imageUrl,
    required this.scientificName,
    required this.description,
    required this.watering,
    required this.bestWatering,
    required this.bestLightCondition,
    required this.bestSoilType,
    required this.toxicity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'access_token': accessToken,
      'common_name': commonName,
      'image_url': imageUrl,
      'scientific_name': scientificName,
      'description': description,
      'watering': watering,
      'best_watering': bestWatering,
      'best_light_condition': bestLightCondition,
      'best_soil_type': bestSoilType,
      'toxicity': toxicity,
    };
  }

  factory PlantIdentification.fromMap(Map<String, dynamic> map) {
    return PlantIdentification(
      id: map['id'],
      accessToken: map['access_token'],
      commonName: map['common_name'],
      imageUrl: map['image_url'],
      scientificName: map['scientific_name'],
      description: map['description'],
      watering: map['watering'],
      bestWatering: map['best_watering'],
      bestLightCondition: map['best_light_condition'],
      bestSoilType: map['best_soil_type'],
      toxicity: map['toxicity'],
    );
  }

  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    final suggestions = json['result']['classification']['suggestions'][0];
    final details = suggestions['details'];

    return PlantIdentification(
      accessToken: json['access_token'] ?? '',
      commonName: (details['common_names'] as List?)?.firstOrNull?.toString() ?? 'Unknown Plant',
      imageUrl: (json['input']['images'] as List?)?.firstOrNull?.toString() ?? '',
      scientificName: suggestions['name'] ?? '',
      description: details['description']?['value'] ?? '',
      watering: jsonEncode(details['watering'] ?? {}),
      bestWatering: details['best_watering'] ?? '',
      bestLightCondition: details['best_light_condition'] ?? '',
      bestSoilType: details['best_soil_type'] ?? '',
      toxicity: details['toxicity'] ?? '',
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'plants_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        access_token TEXT,
        common_name TEXT,
        image_url TEXT,
        scientific_name TEXT,
        description TEXT,
        watering TEXT,
        best_watering TEXT,
        best_light_condition TEXT,
        best_soil_type TEXT,
        toxicity TEXT
      )
    ''');
  }

  Future<int> insertPlant(PlantIdentification plant) async {
    final db = await database;
    return await db.insert(
      'plants',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PlantIdentification>> getPlants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('plants');
    return List.generate(maps.length, (i) => PlantIdentification.fromMap(maps[i]));
  }

  Future<PlantIdentification?> getPlant(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PlantIdentification.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updatePlant(PlantIdentification plant) async {
    final db = await database;
    return await db.update(
      'plants',
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }

  Future<int> deletePlant(int id) async {
    final db = await database;
    return await db.delete(
      'plants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}