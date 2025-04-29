import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  const DeviceTile({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 32),
      title: Text(name),
      subtitle: Text(description),
      onTap: onTap,
    );
  }
}