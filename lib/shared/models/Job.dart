class Job {
  final int? id;
  final String createdAt;
  final String status;
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
}
