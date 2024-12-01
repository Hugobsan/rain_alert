import 'package:rain_alert/shared/db/database_helper.dart';

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

  static Future<int> insert(NotificationModel notification) async {
    final db = await DatabaseHelper().database;
    return await db.insert('notifications', notification.toMap());
  }

  static Future<List<NotificationModel>> getAll() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('notifications');
    return result.map((map) => NotificationModel.fromMap(map)).toList();
  }

  static Future<int> update(NotificationModel notification) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'notifications',
      notification.toMap(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  //Função para deletar a instância atual do objeto no banco
  Future<int> delete() async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Função para persistir no banco o estado atual do objeto
  Future<int> save() async {
    final db = await DatabaseHelper().database;
    return await db.insert('notifications', toMap());
  }
}
