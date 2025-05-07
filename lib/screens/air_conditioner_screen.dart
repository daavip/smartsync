import 'package:flutter/material.dart';
import '../models/device.dart';

class AirConditionerScreen extends StatefulWidget {
  final Device device;
  const AirConditionerScreen({super.key, required this.device});

  @override
  _AirConditionerScreenState createState() => _AirConditionerScreenState();
}

class _AirConditionerScreenState extends State<AirConditionerScreen> {
  double temperature = 22; // Variável de estado para a temperatura

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.device.name)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Temperatura', style: TextStyle(fontSize: 24)),
          Slider(
            value: temperature,
            min: 16,
            max: 30,
            divisions: 14,
            label: '${temperature.round()}°C',
            onChanged: (val) {
              setState(() {
                temperature = val; // Atualiza a temperatura
              });
            },
          ),
          Text('${temperature.round()}°C', style: const TextStyle(fontSize: 32)),
        ],
      ),
    );
  }
}
