import 'package:flutter/material.dart';

enum DeviceType { airConditioner, lamp, assistant, other }

class Device {
  String name;
  String description;
  IconData icon;
  DeviceType type;

  Device({
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
  });
}