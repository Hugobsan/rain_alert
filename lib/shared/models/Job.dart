import 'package:rain_alert/shared/db/database_helper.dart';
class Job {
  final int? id;
  final String createdAt;
  final String status; // pending, finished, queued, cancelled
  final String? canceledAt;
  final String dispatchIn;

  Job({
    this.id,
    required this.createdAt,
    required this.status,
    this.canceledAt,
    required this.dispatchIn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt,
      'status': status,
      'canceled_at': canceledAt,
      'dispatch_in': dispatchIn,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      createdAt: map['created_at'],
      status: map['status'],
      canceledAt: map['canceled_at'],
      dispatchIn: map['dispatch_in'],
    );
  }

  static Future<int> insert(Job job) async {
    final db = await DatabaseHelper().database;
    return await db.insert('jobs', job.toMap());
  }

  static Future<List<Job>> getAll() async {
    final db = await DatabaseHelper().database;
    final result = await db.query('jobs');
    return result.map((map) => Job.fromMap(map)).toList();
  }

  static Future<int> update(Job job) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'jobs',
      job.toMap(),
      where: 'id = ?',
      whereArgs: [job.id],
    );
  }

  static Future<int> delete(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
