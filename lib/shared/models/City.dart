import 'package:rain_alert/shared/db/database_helper.dart';

class City {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? deletedAt;

  City({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.deletedAt,
  });

  // Converte o objeto em um Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'deleted_at': deletedAt,
    };
  }

  // Cria um objeto a partir de um Map do banco
  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      deletedAt: map['deleted_at'],
    );
  }

  // Insere uma cidade no banco
  static Future<int> insert(City city) async {
    final db = await DatabaseHelper().database;
    return await db.insert('cities', city.toMap());
  }

  // Busca todas as cidades no banco
  static Future<List<City>> getAll() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('cities');
    return result.map((map) => City.fromMap(map)).toList();
  }

  // Atualiza uma cidade no banco
  static Future<int> update(City city) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'cities',
      city.toMap(),
      where: 'id = ?',
      whereArgs: [city.id],
    );
  }

  // Deleta uma cidade no banco
  static Future<int> delete(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'cities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
