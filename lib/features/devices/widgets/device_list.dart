import 'package:flutter/material.dart';
import '../../../data/models/device_model.dart';
import '../../../core/widgets/device_card.dart';
import '../screens/device_edit_screen.dart';

class DeviceList extends StatelessWidget {
  final List<Device> devices;
  final Function(Device) onUpdateDevice;
  final bool showEmptyMessage;
  final String? roomId;

  const DeviceList({
    super.key,
    required this.devices,
    required this.onUpdateDevice,
    this.showEmptyMessage = true,
    this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty && showEmptyMessage) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum dispositivo ${roomId != null ? 'neste cômodo' : 'cadastrado'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              roomId != null
                  ? 'Adicione dispositivos a este cômodo na aba Dispositivos'
                  : 'Toque no botão + para adicionar um dispositivo',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return DeviceCard(
          key: ValueKey(device.id),
          device: device,
          onUpdate: onUpdateDevice,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeviceEditScreen(device: device),
              ),
            );
          },
        );
      },
    );
  }
}
