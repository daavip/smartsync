import 'package:flutter/material.dart';
import '../models/device.dart';
import '../widgets/device_tile.dart';
import 'air_conditioner_screen.dart';
import 'lamp_screen.dart';
import 'assistant_screen.dart';
import 'generic_device_screen.dart';

class DevicesScreen extends StatefulWidget {
  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final List<Device> _devices = [];

  void _addDevice() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DeviceType selectedType = DeviceType.other;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Dispositivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            DropdownButton<DeviceType>(
              value: selectedType,
              items: DeviceType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              )).toList(),
              onChanged: (type) => setState(() => selectedType = type!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              IconData icon = Icons.devices;
              switch (selectedType) {
                case DeviceType.airConditioner:
                  icon = Icons.ac_unit;
                  break;
                case DeviceType.lamp:
                  icon = Icons.lightbulb;
                  break;
                case DeviceType.assistant:
                  icon = Icons.speaker;
                  break;
                default:
                  icon = Icons.devices;
              }
              setState(() {
                _devices.add(Device(
                  name: nameController.text,
                  description: descriptionController.text,
                  icon: icon,
                  type: selectedType,
                ));
              });
              Navigator.pop(context);
            },
            child: Text('Adicionar'),
          )
        ],
      ),
    );
  }

  void _navigateToDevice(Device device) {
    Widget screen;
    switch (device.type) {
      case DeviceType.airConditioner:
        screen = AirConditionerScreen(device: device);
        break;
      case DeviceType.lamp:
        screen = LampScreen(device: device);
        break;
      case DeviceType.assistant:
        screen = AssistantScreen(device: device);
        break;
      default:
        screen = GenericDeviceScreen(device: device);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispositivos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addDevice,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Dispositivos'),
          BottomNavigationBarItem(icon: Icon(Icons.room), label: 'Cômodos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
        ],
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return DeviceTile(
            name: device.name,
            description: device.description,
            icon: device.icon,
            onTap: () => _navigateToDevice(device),
          );
        },
      ),
    );
  }
}
