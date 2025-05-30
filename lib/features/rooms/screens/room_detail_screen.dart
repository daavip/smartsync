import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/device_provider.dart';
import '../../../../data/providers/room_provider.dart';
import '../../../../core/widgets/device_card.dart';
import '../../devices/screens/device_edit_screen.dart';

class RoomDetailScreen extends StatelessWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final deviceProvider = Provider.of<DeviceProvider>(context);
    
    final room = roomProvider.rooms.firstWhere((r) => r.id == roomId);
    final devicesInRoom = deviceProvider.devices
        .where((device) => room.deviceIds.contains(device.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: ListView.builder(
        itemCount: devicesInRoom.length,
        itemBuilder: (context, index) {
          final device = devicesInRoom[index];
          return DeviceCard(
            name: device.name,
            room: room.name,
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
    );
  }
}