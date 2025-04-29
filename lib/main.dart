import 'package:flutter/material.dart';
import 'screens/devices_screens.dart';

void main() => runApp(SmartSinkApp());

class SmartSinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Sink',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: DevicesScreen(),
    );
  }
}
