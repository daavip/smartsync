import 'package:flutter/material.dart';

enum DeviceType {
  light('Lâmpada', Icons.lightbulb),
  airConditioner('Ar-condicionado', Icons.ac_unit),
  tv('Televisão', Icons.tv),
  speaker('Alto-falante', Icons.speaker);

  final String label;
  final IconData icon;

  const DeviceType(this.label, this.icon);
}
