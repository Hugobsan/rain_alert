class Settings {
  final int? id;
  final String tempUnit; // Unidade de temperatura (C, K, F)
  final int predCitiesCount; // Quantidade de cidades para predição
  final String windUnit; // Unidade de vento (km/h, m/s, etc.)
  final String pressureUnit; // Unidade de pressão (hPa, mmHg, etc.)
  final String preferUpdateTime; // Horário preferido para atualização

  Settings({
    this.id,
    required this.tempUnit,
    required this.predCitiesCount,
    required this.windUnit,
    required this.pressureUnit,
    required this.preferUpdateTime,
  });

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
}
