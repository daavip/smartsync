import 'package:flutter/material.dart';
import 'device_type.dart';

abstract class DeviceSettings {
  Map<String, dynamic> toJson();
  DeviceType get type;
}

class LightSettings implements DeviceSettings {
  final double brightness;
  final Color color;

  LightSettings({
    this.brightness = 1.0,
    this.color = Colors.white,
  });

  @override
  DeviceType get type => DeviceType.light;

  @override
  Map<String, dynamic> toJson() => {
        'brightness': brightness,
        'color': color.value,
      };

  factory LightSettings.fromJson(Map<String, dynamic> json) {
    return LightSettings(
      brightness: json['brightness'] ?? 1.0,
      color: Color(json['color'] ?? Colors.white.value),
    );
  }
}

class AirConditionerSettings implements DeviceSettings {
  final double temperature;
  final bool isAuto;
  final String mode; // cool, heat, fan, dry

  AirConditionerSettings({
    this.temperature = 23.0,
    this.isAuto = false,
    this.mode = 'cool',
  });

  @override
  DeviceType get type => DeviceType.airConditioner;

  @override
  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'isAuto': isAuto,
        'mode': mode,
      };

  factory AirConditionerSettings.fromJson(Map<String, dynamic> json) {
    return AirConditionerSettings(
      temperature: json['temperature'] ?? 23.0,
      isAuto: json['isAuto'] ?? false,
      mode: json['mode'] ?? 'cool',
    );
  }
}

class TVSettings implements DeviceSettings {
  final int volume;
  final String input; // hdmi1, hdmi2, tv, etc
  final bool isMuted;
  final String channel;

  TVSettings({
    this.volume = 20,
    this.input = 'hdmi1',
    this.isMuted = false,
    this.channel = '1',
  });

  @override
  DeviceType get type => DeviceType.tv;

  @override
  Map<String, dynamic> toJson() => {
        'volume': volume,
        'input': input,
        'isMuted': isMuted,
        'channel': channel,
      };

  factory TVSettings.fromJson(Map<String, dynamic> json) {
    return TVSettings(
      volume: json['volume'] ?? 20,
      input: json['input'] ?? 'hdmi1',
      isMuted: json['isMuted'] ?? false,
      channel: json['channel'] ?? '1',
    );
  }
}

class SpeakerSettings implements DeviceSettings {
  final int volume;
  final bool isMuted;
  final double bass;
  final double treble;
  final String input; // bluetooth, aux, optical

  SpeakerSettings({
    this.volume = 50,
    this.isMuted = false,
    this.bass = 0,
    this.treble = 0,
    this.input = 'bluetooth',
  });

  @override
  DeviceType get type => DeviceType.speaker;

  @override
  Map<String, dynamic> toJson() => {
        'volume': volume,
        'isMuted': isMuted,
        'bass': bass,
        'treble': treble,
        'input': input,
      };

  factory SpeakerSettings.fromJson(Map<String, dynamic> json) {
    return SpeakerSettings(
      volume: json['volume'] ?? 50,
      isMuted: json['isMuted'] ?? false,
      bass: json['bass']?.toDouble() ?? 0,
      treble: json['treble']?.toDouble() ?? 0,
      input: json['input'] ?? 'bluetooth',
    );
  }
} 