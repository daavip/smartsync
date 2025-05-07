import 'package:flutter/material.dart';
import '../models/device.dart';

class GenericDeviceScreen extends StatelessWidget {
  final Device device;
  const GenericDeviceScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: Center(
        child: Text('Controle genérico para ${device.name}', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
