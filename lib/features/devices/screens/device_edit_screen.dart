import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/device_model.dart';
import '../../../../data/models/device_type.dart';
import '../../../../data/providers/device_provider.dart';
import '../../../../data/providers/room_provider.dart';

class DeviceEditScreen extends StatefulWidget {
  final Device device;

  const DeviceEditScreen({super.key, required this.device});

  @override
  State<DeviceEditScreen> createState() => _DeviceEditScreenState();
}

class _DeviceEditScreenState extends State<DeviceEditScreen> {
  late final TextEditingController _nameController;
  late String _selectedRoomId;
  late DeviceType _selectedType;
  late bool _isOn;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _selectedRoomId = widget.device.roomId;
    _selectedType = widget.device.type;
    _isOn = widget.device.isOn;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveDevice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);
      final updatedDevice = Device(
        id: widget.device.id,
        name: _nameController.text.trim(),
        roomId: _selectedRoomId,
        type: _selectedType,
        isOn: _isOn,
      );

      if (widget.device.id.isEmpty) {
        await deviceProvider.addDevice(updatedDevice);
      } else {
        await deviceProvider.updateDevice(updatedDevice);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispositivo salvo com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar dispositivo: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteDevice() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este dispositivo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final deviceProvider =
          Provider.of<DeviceProvider>(context, listen: false);
      await deviceProvider.deleteDevice(widget.device.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispositivo excluído com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir dispositivo: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.device.id.isEmpty ? 'Novo Dispositivo' : 'Editar Dispositivo',
        ),
        actions: [
          if (widget.device.id.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isSaving ? null : _deleteDevice,
            ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveDevice,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Dispositivo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.devices),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira um nome para o dispositivo';
                  }
                  return null;
                },
                enabled: !_isSaving,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.device.id.isEmpty,
              ),
              const SizedBox(height: 16),
              if (roomProvider.rooms.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Adicione um cômodo primeiro para poder adicionar dispositivos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                )
              else ...[
                DropdownButtonFormField<String>(
                  value: roomProvider.rooms
                          .any((room) => room.id == _selectedRoomId)
                      ? _selectedRoomId
                      : roomProvider.rooms.first.id,
                  decoration: const InputDecoration(
                    labelText: 'Cômodo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.room),
                  ),
                  items: roomProvider.rooms.map((room) {
                    return DropdownMenuItem<String>(
                      value: room.id,
                      child: Text(room.name),
                    );
                  }).toList(),
                  onChanged: !_isSaving
                      ? (value) {
                          if (value != null) {
                            setState(() => _selectedRoomId = value);
                          }
                        }
                      : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um cômodo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DeviceType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Dispositivo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: DeviceType.values.map((type) {
                    return DropdownMenuItem<DeviceType>(
                      value: type,
                      child: Row(
                        children: [
                          Icon(type.icon),
                          const SizedBox(width: 8),
                          Text(type.label),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: !_isSaving && widget.device.id.isEmpty
                      ? (value) {
                          if (value != null) {
                            setState(() => _selectedType = value);
                          }
                        }
                      : null,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione um tipo de dispositivo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Dispositivo ligado'),
                  value: _isOn,
                  onChanged: !_isSaving
                      ? (value) {
                          setState(() => _isOn = value);
                          HapticFeedback.lightImpact();
                        }
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
