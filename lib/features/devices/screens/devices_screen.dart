import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/device_provider.dart';
import '../../../data/providers/room_provider.dart';
import '../widgets/device_list.dart';
import 'device_edit_screen.dart';
import '../../../data/models/device_model.dart';
import '../../../data/models/device_type.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
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
      body: Consumer2<DeviceProvider, RoomProvider>(
        builder: (context, deviceProvider, roomProvider, child) {
          if (deviceProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (roomProvider.rooms.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Adicione um cômodo primeiro para poder adicionar dispositivos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          return DeviceList(
            devices: deviceProvider.devices,
            onUpdateDevice: deviceProvider.updateDevice,
          );
        },
      ),
      floatingActionButton: Consumer<RoomProvider>(
        builder: (context, roomProvider, _) {
          if (roomProvider.rooms.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceEditScreen(
                    device: Device(
                      id: '',
                      name: '',
                      roomId: roomProvider.rooms.first.id,
                      type: DeviceType.light,
                      isOn: false,
                    ),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
