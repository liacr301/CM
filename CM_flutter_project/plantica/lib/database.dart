import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class PlantIdentification {
  final int? id;
  final int? userId;
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
  final String? lastWatered;
  final String? wateringFrequency;

  PlantIdentification({
    this.id,
    this.userId,
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
    this.lastWatered,
    this.wateringFrequency,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
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
      'last_watered': lastWatered,
      'watering_frequency': wateringFrequency,
    };
  }

  factory PlantIdentification.fromMap(Map<String, dynamic> map) {
    return PlantIdentification(
      id: map['id'],
      userId: map['userId'],
      accessToken: map['access_token'] ?? '',
      commonName: map['common_name'],
      imageUrl: map['image_url'],
      scientificName: map['scientific_name'],
      description: map['description'],
      watering: map['watering'],
      bestWatering: map['best_watering'],
      bestLightCondition: map['best_light_condition'],
      bestSoilType: map['best_soil_type'],
      toxicity: map['toxicity'],
      lastWatered: map['last_watered'],
      wateringFrequency: map['watering_frequency'],
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

class User {
  final int? id;
  final String name;
  final String username;
  final String birthdate;
  final String password;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.birthdate,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'birthdate': birthdate,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      birthdate: map['birthdate'],
      password: map['password'],
    );
  }
}

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'plant_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        birthdate TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create plants table with all fields from both implementations
    await db.execute('''
      CREATE TABLE plants(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        access_token TEXT,
        common_name TEXT,
        image_url TEXT,
        scientific_name TEXT,
        description TEXT,
        watering TEXT,
        best_watering TEXT,
        best_light_condition TEXT,
        best_soil_type TEXT,
        toxicity TEXT,
        last_watered TEXT,
        watering_frequency TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // User-related methods
  Future<int> registerUser(String name, String username, String birthdate, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {
        'name': name,
        'username': username,
        'birthdate': birthdate,
        'password': password,
      },
    );
  }

  Future<User?> loginUser(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    }
    return null;
  }

  // Plant-related methods
  Future<int> insertPlant(PlantIdentification plant) async {
    final db = await database;
    return await db.insert(
      'plants',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PlantIdentification>> getPlants({int? userId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plants',
      where: userId != null ? 'userId = ?' : null,
      whereArgs: userId != null ? [userId] : null,
    );
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

  Future<int> updatePlantWateringInfo(int plantId, String lastWatered) async {
    final db = await database;
    return await db.update(
      'plants',
      {'last_watered': lastWatered},
      where: 'id = ?',
      whereArgs: [plantId],
    );
  }
  

  Future<List<Map<String, dynamic>>> getAllPlants() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'plants',
      columns: ['id', 'common_name', 'scientific_name', 'image_url', 'watering'],
    );
    return result;
  }
}