import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import '../../../../data/models/room_model.dart';
import '../../../../data/providers/room_provider.dart';

class RoomEditScreen extends StatefulWidget {
  final Room room;

  const RoomEditScreen({super.key, required this.room});

  @override
  State<RoomEditScreen> createState() => _RoomEditScreenState();
}

class _RoomEditScreenState extends State<RoomEditScreen> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  String? _selectedResidenciaId;
  List<Map<String, dynamic>> _residencias = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room.name);
    _carregarResidencias();
  }

  Future<void> _carregarResidencias() async {
    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioId = prefs.getString('usuario_id');
      if (usuarioId != null) {
        final api = ApiService();
        final lista = await api.listarResidenciasPorUsuario(usuarioId);
        setState(() {
          _residencias = lista;
          if (_residencias.isNotEmpty) {
            _selectedResidenciaId = _residencias.first['id'];
          }
        });
      }
    } catch (_) {}
    setState(() => _isSaving = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveRoom() async {
    if (!_formKey.currentState!.validate() || _selectedResidenciaId == null)
      return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final api = ApiService();
      final uuid = const Uuid();
      final now = DateTime.now().toUtc().toIso8601String();
      final comodoJson = {
        'id': uuid.v4(),
        'createdAt': now,
        'nome': _nameController.text.trim(),
        'residenciaId': _selectedResidenciaId,
        'dispositivos': [],
      };
      await api.addComodo(comodoJson);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cômodo salvo com sucesso!'),
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
            content: Text('Erro ao salvar cômodo: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.id.isEmpty ? 'Novo Cômodo' : 'Editar Cômodo'),
        actions: [
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
              onPressed: _saveRoom,
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
                  labelText: 'Nome do Cômodo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.room),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira um nome para o cômodo';
                  }
                  return null;
                },
                enabled: !_isSaving,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.room.id.isEmpty,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedResidenciaId,
                items: _residencias.map((res) {
                  return DropdownMenuItem<String>(
                    value: res['id'],
                    child: Text(res['endereco'] ?? 'Sem endereço'),
                  );
                }).toList(),
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _selectedResidenciaId = value;
                        });
                      },
                decoration: const InputDecoration(
                  labelText: 'Residência',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione uma residência';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
