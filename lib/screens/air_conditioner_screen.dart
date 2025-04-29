import 'package:flutter/material.dart';
import '../models/device.dart';

class AirConditionerScreen extends StatelessWidget {
  final Device device;
  const AirConditionerScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    double temperature = 22;
    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Temperatura', style: TextStyle(fontSize: 24)),
          Slider(
            value: temperature,
            min: 16,
            max: 30,
            divisions: 14,
            label: '${temperature.round()}°C',
            onChanged: (val) {},
          ),
          Text('${temperature.round()}°C', style: TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}
