import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/device_model.dart';
import '../../../../data/providers/device_provider.dart';
import '../../../../data/providers/room_provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';

class DeviceEditScreen extends StatefulWidget {
  final Device device;

  const DeviceEditScreen({super.key, required this.device});

  @override
  State<DeviceEditScreen> createState() => _DeviceEditScreenState();
}

class _DeviceEditScreenState extends State<DeviceEditScreen> {
  late final TextEditingController _nameController;
  late String _selectedRoomId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _selectedRoomId = widget.device.roomId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editDevice),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updatedDevice = widget.device.copyWith(
                  name: _nameController.text,
                  roomId: _selectedRoomId,
                );

                if (widget.device.id.isEmpty) {
                  await deviceProvider.addDevice(updatedDevice);
                } else {
                  await deviceProvider.updateDevice(updatedDevice);
                }

                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.deviceName,
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateName,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRoomId.isNotEmpty ? _selectedRoomId : null,
                decoration: const InputDecoration(
                  labelText: 'Cômodo',
                  border: OutlineInputBorder(),
                ),
                items: roomProvider.rooms.map((room) {
                  return DropdownMenuItem<String>(
                    value: room.id,
                    child: Text(room.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRoomId = value;
                    });
                  }
                },
                validator: Validators.validateRoom,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Dispositivo ligado'),
                value: widget.device.isOn,
                onChanged: (value) {
                  // Implementar mudança de estado se necessário
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}