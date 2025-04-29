import 'package:flutter/material.dart';
import '../models/device.dart';

class AssistantScreen extends StatelessWidget {
  final Device device;
  const AssistantScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 100, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text('Comando de voz disponível', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}