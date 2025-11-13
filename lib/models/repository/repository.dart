class Repository {
  final int id;
  final String owner;
  final String name;
  final int pollIntervalSeconds;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Repository({
    required this.id,
    required this.owner,
    required this.name,
    required this.isActive,
    required this.pollIntervalSeconds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      pollIntervalSeconds: json['poll_interval_seconds'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
