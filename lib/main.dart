import 'package:flutter/material.dart';
import 'screens/devices_screens.dart';

void main() => runApp(SmartSyncApp());

class SmartSyncApp extends StatelessWidget {
  const SmartSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Sink',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: DevicesScreen(),
    );
  }
}
