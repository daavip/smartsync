class Residencia {
  final String id;
  String name;

  Residencia({
    required this.id,
    required this.name,
  });

  Residencia copyWith({
    String? id,
    String? name,
  }) {
    return Residencia(
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

  factory Residencia.fromJson(Map<String, dynamic> json) {
    return Residencia(
      id: json['id'],
      name: json['name'],
    );
  }
}
