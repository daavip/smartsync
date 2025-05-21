import 'package:flutter/material.dart';

class DevicesPage extends StatelessWidget {
  final DevicesController controller = DevicesController();

  @override
  Widget build(BuildContext context) {
    final devices = controller.getDevices();

    return Scaffold(
      appBar: AppBar(title: Text('Dispositivos')),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device['name']!),
            subtitle: Text('Cômodo: ${device['room']}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Editar ${device['name']}'),
                  ),
                );
              },
            ),
          );
        },
        padding: EdgeInsets.all(16),
        children: [
          DeviceCard(
            name: 'Lâmpada',
            room: 'Sala',
            onEdit:
                () => showDialog(
                  context: context,
                  builder: (_) => EditDeviceDialog(),
                ),
          ),
        ],
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String name;
  final String room;
  final VoidCallback onEdit;

  DeviceCard({required this.name, required this.room, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('Cômodo: $room'),
        trailing: IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
      ),
    );
  }
}

class EditDeviceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Dispositivo'),
      content: Text('Formulário de edição aqui.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
