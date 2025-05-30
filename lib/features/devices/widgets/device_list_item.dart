import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class DeviceListItem extends StatelessWidget {
  final String name;
  final String room;
  final bool isOn;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const DeviceListItem({
    super.key,
    required this.name,
    required this.room,
    required this.isOn,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          isOn ? Icons.lightbulb : Icons.lightbulb_outline,
          color: isOn ? AppColors.accentColor : AppColors.lightTextColor,
          size: 32,
        ),
        title: Text(name, style: AppStyles.subtitleStyle),
        subtitle: Text(room, style: AppStyles.bodyStyle),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: AppColors.primaryColor),
          onPressed: onEdit,
        ),
        onTap: onTap,
      ),
    );
  }
}