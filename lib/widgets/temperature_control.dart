import 'package:flutter/material.dart';

class TemperatureControl extends StatelessWidget {
  final int temperature;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const TemperatureControl({
    super.key,
    required this.temperature,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.remove), onPressed: onDecrease),
        Text('$temperature° C', style: TextStyle(fontSize: 24)),
        IconButton(icon: Icon(Icons.add), onPressed: onIncrease),
      ],
    );
  }
}
