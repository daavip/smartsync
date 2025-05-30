import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class RoomListItem extends StatelessWidget {
  final String name;
  final int deviceCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const RoomListItem({
    super.key,
    required this.name,
    required this.deviceCount,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(
          Icons.room,
          color: AppColors.secondaryColor,
          size: 32,
        ),
        title: Text(name, style: AppStyles.subtitleStyle),
        subtitle: Text('$deviceCount dispositivos', style: AppStyles.bodyStyle),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: AppColors.primaryColor),
          onPressed: onEdit,
        ),
        onTap: onTap,
      ),
    );
  }
}