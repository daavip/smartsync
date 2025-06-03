import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/device_provider.dart';
import '../../../../data/providers/room_provider.dart';
import '../../devices/widgets/device_list.dart';
import '../../devices/screens/device_edit_screen.dart';
import '../../../../data/models/device_model.dart';
import '../../../../data/models/device_type.dart';

class RoomDetailScreen extends StatelessWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Selector<RoomProvider, String>(
          selector: (_, provider) =>
              provider.rooms.firstWhere((r) => r.id == roomId).name,
          builder: (context, roomName, _) => Text(roomName),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DeviceProvider>().loadDevices();
              context.read<RoomProvider>().loadRooms();
            },
          ),
        ],
      ),
      body: Selector<DeviceProvider, List<Device>>(
        selector: (_, provider) => provider.devices
            .where((device) => device.roomId == roomId)
            .toList(),
        builder: (context, devicesInRoom, _) {
          return DeviceList(
            devices: devicesInRoom,
            onUpdateDevice: context.read<DeviceProvider>().updateDevice,
            roomId: roomId,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeviceEditScreen(
                device: Device(
                  id: '',
                  name: '',
                  roomId: roomId,
                  type: DeviceType.light,
                  isOn: false,
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
