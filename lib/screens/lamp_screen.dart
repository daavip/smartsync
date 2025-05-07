import 'package:flutter/material.dart';
import '../models/device.dart';

class LampScreen extends StatefulWidget {
  final Device device;
  const LampScreen({super.key, required this.device});

  @override
  LampScreenState createState() => LampScreenState();
}

class LampScreenState extends State<LampScreen> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.device.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOn ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 100,
              color: isOn ? Colors.yellow : Colors.grey,
            ),
            Switch(
              value: isOn,
              onChanged: (value) => setState(() => isOn = value),
            )
          ],
        ),
      ),
    );
  }
}
