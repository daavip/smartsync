import 'package:flutter/material.dart';
import '../models/device.dart';
import '../widgets/main_navigation.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final List<Map<String, dynamic>> _rooms = []; // Lista de cômodos
  final List<Device> _devices = [
    // Dispositivos disponíveis para seleção
    Device(
      name: 'Ar Condicionado',
      description: 'Ar condicionado da sala',
      icon: Icons.ac_unit,
      type: DeviceType.airConditioner,
    ),
    Device(
      name: 'Lâmpada',
      description: 'Lâmpada do quarto',
      icon: Icons.lightbulb,
      type: DeviceType.lamp,
    ),
  ];

  void _addRoom() {
    final nameController = TextEditingController();
    final List<Device> selectedDevices = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Text('Adicionar Cômodo'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Cômodo',
                      hintText: 'Ex: Sala de Estar',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Selecione os dispositivos:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._devices.map((device) {
                    final isSelected = selectedDevices.contains(device);
                    return CheckboxListTile(
                      title: Text(device.name),
                        subtitle: Text(
                        device.description,
                        style: const TextStyle(
                          fontSize: 12,  // Altere a cor da fonte
                          ),
                        ),
                      secondary: Icon(device.icon),
                      value: isSelected,
                      onChanged: (value) {
                        setModalState(() {
                          if (value == true) {
                            selectedDevices.add(device);
                          } else {
                            selectedDevices.remove(device);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Adiciona o cômodo sem dispositivos
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      _rooms.add({
                        'name': nameController.text,
                        'devices': [],
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Pular'),
              ),
              TextButton(
                onPressed: () {
                  // Adiciona o cômodo com dispositivos selecionados
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      _rooms.add({
                        'name': nameController.text,
                        'devices': selectedDevices,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Finalizar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cômodos')),
      bottomNavigationBar: const MainNavigation(currentIndex: 1),
      body: _rooms.isEmpty
          ? const Center(
              child: Text(
                'Nenhum cômodo cadastrado.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                return ListTile(
                  title: Text(room['name']),
                  subtitle: Text(
                    room['devices'].isEmpty
                        ? 'Nenhum dispositivo'
                        : '${room['devices'].length} dispositivo(s)',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Exibe detalhes do cômodo
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(room['name']),
                        content: room['devices'].isEmpty
                            ? const Text('Nenhum dispositivo neste cômodo.')
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: room['devices']
                                    .map<Widget>((device) => ListTile(
                                          leading: Icon(device.icon),
                                          title: Text(device.name),
                                          subtitle: Text(device.description),
                                        ))
                                    .toList(),
                              ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addRoom,
        child: const Icon(Icons.add),
      ),
    );
  }
}