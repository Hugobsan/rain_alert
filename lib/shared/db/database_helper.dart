import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'rain_alert.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE cities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      latitude REAL NOT NULL,
      longitude REAL NOT NULL,
      deleted_at TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      city_id INTEGER NOT NULL,
      text TEXT NOT NULL,
      color_primary TEXT NOT NULL,
      color_secondary TEXT NOT NULL,
      icon TEXT NOT NULL,
      FOREIGN KEY (city_id) REFERENCES cities (id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE jobs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      created_at TEXT NOT NULL,
      status TEXT NOT NULL CHECK(status IN ('pending', 'finished', 'queued', 'cancelled')),
      canceled_at TEXT,
      dispatch_in TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE settings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      temp_unit TEXT NOT NULL CHECK(temp_unit IN ('C', 'K', 'F')),
      pred_cities_count INTEGER NOT NULL,
      wind_unit TEXT NOT NULL,
      pressure_unit TEXT NOT NULL,
      prefer_update_time TEXT NOT NULL
    )
  ''');

    await db.insert('settings', {
      'temp_unit': 'C',
      'pred_cities_count': 6,
      'wind_unit': 'km/h',
      'pressure_unit': 'hPa',
      'prefer_update_time': '08:00',
    });
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    final db = await database;
    await db.execute(sql, arguments);
  }
}
