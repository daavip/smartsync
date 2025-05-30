import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/device_provider.dart';
import '../../../../data/providers/room_provider.dart';
import '../../../../core/widgets/device_card.dart';
import 'device_edit_screen.dart';
import '../../../../data/models/device_model.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              deviceProvider.loadDevices();
              roomProvider.loadRooms();
            },
          ),
        ],
      ),
      body:
          deviceProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: deviceProvider.devices.length,
                itemBuilder: (context, index) {
                  final device = deviceProvider.devices[index];
                  final roomName = roomProvider.getRoomNameById(device.roomId);
                  return DeviceCard(
                    name: device.name,
                    room: roomName,
                    isOn: device.isOn,
                    onTap: () {
                      deviceProvider.toggleDeviceStatus(device.id);
                    },
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
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DeviceEditScreen(
                    device: Device(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: 'Novo Dispositivo',
                      roomId:
                          roomProvider.rooms.isNotEmpty
                              ? roomProvider.rooms.first.id
                              : '',
                    ),
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
