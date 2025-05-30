import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class SettingOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingOption({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor, size: 28),
        title: Text(title, style: AppStyles.subtitleStyle),
        subtitle: Text(subtitle, style: AppStyles.bodyStyle),
        trailing: const Icon(Icons.chevron_right, color: AppColors.lightTextColor),
        onTap: () {
          // Implementar navegação para configurações específicas
        },
      ),
    );
  }
}