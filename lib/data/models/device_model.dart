import 'device_type.dart';
import 'device_settings.dart';

class Device {
  final String id;
  final String name;
  final String roomId;
  final DeviceType type;
  bool isOn;
  DeviceSettings settings;

  Device({
    required this.id,
    required this.name,
    required this.roomId,
    required this.type,
    this.isOn = false,
    DeviceSettings? settings,
  }) : settings = settings ?? _getDefaultSettings(type);

  Device copyWith({
    String? id,
    String? name,
    String? roomId,
    DeviceType? type,
    bool? isOn,
    DeviceSettings? settings,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      roomId: roomId ?? this.roomId,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      settings: settings ?? this.settings,
    );
  }

  static DeviceSettings _getDefaultSettings(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return LightSettings();
      case DeviceType.airConditioner:
        return AirConditionerSettings();
      case DeviceType.tv:
        return TVSettings();
      case DeviceType.speaker:
        return SpeakerSettings();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roomId': roomId,
      'type': type.name,
      'isOn': isOn,
      'settings': settings.toJson(),
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    final type = DeviceType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => DeviceType.light,
    );

    DeviceSettings settings;
    final settingsJson = Map<String, dynamic>.from(json['settings'] ?? {});

    switch (type) {
      case DeviceType.light:
        settings = LightSettings.fromJson(settingsJson);
        break;
      case DeviceType.airConditioner:
        settings = AirConditionerSettings.fromJson(settingsJson);
        break;
      case DeviceType.tv:
        settings = TVSettings.fromJson(settingsJson);
        break;
      case DeviceType.speaker:
        settings = SpeakerSettings.fromJson(settingsJson);
        break;
    }

    return Device(
      id: json['id'],
      name: json['name'],
      roomId: json['roomId'],
      type: type,
      isOn: json['isOn'] ?? false,
      settings: settings,
    );
  }
}
