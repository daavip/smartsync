class Room {
  final String id;
  String name;
  final List<String> deviceIds;

  Room({
    required this.id,
    required this.name,
    this.deviceIds = const [],
  });

  Room copyWith({
    String? id,
    String? name,
    List<String>? deviceIds,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceIds: deviceIds ?? this.deviceIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'deviceIds': deviceIds,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      deviceIds: List<String>.from(json['deviceIds']),
    );
  }
}