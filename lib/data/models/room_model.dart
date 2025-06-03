class Room {
  final String id;
  String name;

  Room({
    required this.id,
    required this.name,
  });

  Room copyWith({
    String? id,
    String? name,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
    );
  }
}
