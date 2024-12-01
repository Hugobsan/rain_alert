class NotificationModel {
  final int? id;
  final String type;
  final int cityId;
  final String text;
  final String colorPrimary;
  final String colorSecondary;
  final String icon;

  NotificationModel({
    this.id,
    required this.type,
    required this.cityId,
    required this.text,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'city_id': cityId,
      'text': text,
      'color_primary': colorPrimary,
      'color_secondary': colorSecondary,
      'icon': icon,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      type: map['type'],
      cityId: map['city_id'],
      text: map['text'],
      colorPrimary: map['color_primary'],
      colorSecondary: map['color_secondary'],
      icon: map['icon'],
    );
  }
}