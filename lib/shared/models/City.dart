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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'deleted_at': deletedAt,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      deletedAt: map['deleted_at'],
    );
  }
}
