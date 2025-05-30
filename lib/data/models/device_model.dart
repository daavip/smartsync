class Device {
  final String id;
  final String name;
  final String roomId;
  bool isOn;
  final Map<String, dynamic> settings;

  Device({
    required this.id,
    required this.name,
    required this.roomId,
    this.isOn = false,
    this.settings = const {},
  });

  Device copyWith({
    String? id,
    String? name,
    String? roomId,
    bool? isOn,
    Map<String, dynamic>? settings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      roomId: roomId ?? this.roomId,
      isOn: isOn ?? this.isOn,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roomId': roomId,
      'isOn': isOn,
      'settings': settings,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      roomId: json['roomId'],
      isOn: json['isOn'],
      settings: Map<String, dynamic>.from(json['settings']),
    );
  }
}