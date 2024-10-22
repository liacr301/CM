import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'users.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL,
        birthdate TEXT NOT NULL,
        password TEXT NOT NULL
      )
      ''',
    );
    await db.execute(
      '''
      CREATE TABLE plants(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        image TEXT NOT NULL,
        name TEXT NOT NULL,
        species TEXT NOT NULL,
        wateringFrequency TEXT NOT NULL,
        lastWatered TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
      ''',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE users ADD COLUMN name TEXT;
      ''');
      await db.execute('''
        ALTER TABLE users ADD COLUMN birthdate TEXT;
      ''');
    }

    if (oldVersion < 3) {
      await db.execute(
        '''
        CREATE TABLE plants(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          image TEXT NOT NULL,
          name TEXT NOT NULL,
          species TEXT NOT NULL,
          wateringFrequency TEXT NOT NULL,
          lastWatered TEXT,
          FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
        )
        ''',
      );
    }
  }

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

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (users.isNotEmpty) {
      return users.first; 
    } else {
      return null; 
    }
  }

  Future<int> addPlant(int userId, String img, String name, String species, String wateringFrequency, String lastWatered) async {
    final db = await database;
    return await db.insert(
      'plants',
      {
        'image' : img,
        'userId': userId,
        'name': name,
        'species': species,
        'wateringFrequency': wateringFrequency,
        'lastWatered': lastWatered,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPlants(int userId) async {
    final db = await database;
    return await db.query(
      'plants',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
