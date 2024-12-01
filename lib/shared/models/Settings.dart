import 'package:rain_alert/shared/db/database_helper.dart';

class Settings {
  final int? id;
  final String tempUnit;
  final int predCitiesCount;
  final String windUnit;
  final String pressureUnit;
  final String preferUpdateTime;

  Settings({
    this.id,
    required this.tempUnit,
    required this.predCitiesCount,
    required this.windUnit,
    required this.pressureUnit,
    required this.preferUpdateTime,
  });

  /// Método para criar uma nova instância de Settings com alterações específicas
  Settings copyWith({
    int? id,
    String? tempUnit,
    int? predCitiesCount,
    String? windUnit,
    String? pressureUnit,
    String? preferUpdateTime,
  }) {
    return Settings(
      id: id ?? this.id,
      tempUnit: tempUnit ?? this.tempUnit,
      predCitiesCount: predCitiesCount ?? this.predCitiesCount,
      windUnit: windUnit ?? this.windUnit,
      pressureUnit: pressureUnit ?? this.pressureUnit,
      preferUpdateTime: preferUpdateTime ?? this.preferUpdateTime,
    );
  }

  /// Converte o objeto em um Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'temp_unit': tempUnit,
      'pred_cities_count': predCitiesCount,
      'wind_unit': windUnit,
      'pressure_unit': pressureUnit,
      'prefer_update_time': preferUpdateTime,
    };
  }

  /// Cria um objeto a partir de um Map do banco
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      id: map['id'],
      tempUnit: map['temp_unit'],
      predCitiesCount: map['pred_cities_count'],
      windUnit: map['wind_unit'],
      pressureUnit: map['pressure_unit'],
      preferUpdateTime: map['prefer_update_time'],
    );
  }

  static Future<Settings?> getSettings() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('settings');
    if (result.isNotEmpty) {
      return Settings.fromMap(result.first);
    }
    return null;
  }

  static Future<int> update(Settings settings) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }
}
