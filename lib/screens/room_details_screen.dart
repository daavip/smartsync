import 'package:flutter/material.dart';
import '../models/device.dart';

class RoomDetailsScreen extends StatelessWidget {
  final String roomName;
  final List<Device> devices;

  const RoomDetailsScreen({
    super.key,
    required this.roomName,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roomName)),
      body: devices.isEmpty
          ? const Center(
              child: Text(
                'Nenhum dispositivo neste cômodo.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  leading: Icon(device.icon),
                  title: Text(device.name),
                  subtitle: Text(device.description),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Aqui você pode navegar para uma tela específica do dispositivo
                    // ou exibir uma modal para interagir com ele.
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Interagir com ${device.name}'),
                        content: Text('Aqui você pode adicionar interações específicas para o dispositivo.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}