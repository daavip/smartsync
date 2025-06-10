import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import 'ripple_effect.dart';
import 'device_dialogs.dart';
import '../../data/models/device_model.dart';
import '../../data/models/device_type.dart';
import '../services/api_service.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final Function(Device) onUpdate;
  final VoidCallback onEdit;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onUpdate,
    required this.onEdit,
  });

  Future<void> _showDeviceDialog(BuildContext context) async {
    HapticFeedback.lightImpact();

    switch (device.type) {
      case DeviceType.light:
        await DeviceDialogs.showLightDialog(context, device, onUpdate);
        break;
      case DeviceType.airConditioner:
        await DeviceDialogs.showAirConditionerDialog(context, device, onUpdate);
        break;
      case DeviceType.tv:
        await DeviceDialogs.showTVDialog(context, device, onUpdate);
        break;
      case DeviceType.speaker:
        await DeviceDialogs.showSpeakerDialog(context, device, onUpdate);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          RippleEffect(
            onTap: () => _showDeviceDialog(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Ícone com animação implícita
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: device.isOn ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Icon(
                          device.type.icon,
                          color: Color.lerp(
                            AppColors.lightTextColor,
                            AppColors.accentColor,
                            value,
                          ),
                          size: 32,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),

                  // Coluna com textos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: AppStyles.subtitleStyle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          device.type.label,
                          style: AppStyles.bodyStyle.copyWith(
                            color: AppColors.lightTextColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botão de editar separado do RippleEffect
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryColor),
              onPressed: () {
                HapticFeedback.mediumImpact();
                onEdit();
              },
            ),
          ),
        ],
      ),
    );
  }
}
