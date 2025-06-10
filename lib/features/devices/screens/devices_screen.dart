import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/device_provider.dart';
import '../../../data/providers/room_provider.dart';
import '../widgets/device_list.dart';
import 'device_edit_screen.dart';
import '../../../data/models/device_model.dart';
import '../../../data/models/device_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import 'package:uuid/uuid.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<Map<String, dynamic>> _devices = [];
  bool _isLoading = false;
  String? _usuarioId;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDevices();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioId = prefs.getString('usuario_id');
    });
    await _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _isLoading = true);
    if (_usuarioId != null) {
      final api = ApiService();
      final lista = await api.listarDispositivosPorUsuario(_usuarioId!);
      setState(() {
        _devices = lista;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _adicionarDispositivo() async {
    final nomeController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String? comodoId;
    String? tipoId;
    String? tipoNomeNovo;
    bool ligado = true;
    List<Map<String, dynamic>> comodos = [];
    List<Map<String, dynamic>> tipos = [];
    bool criandoTipo = false;

    // Buscar comodos e tipos
    if (_usuarioId != null) {
      final api = ApiService();
      comodos = await api.listarComodosPorUsuario(_usuarioId!);
      tipos = await api.listarTiposDispositivo();
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Adicionar Dispositivo'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration:
                        const InputDecoration(labelText: 'Nome do dispositivo'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: comodoId,
                    items: comodos
                        .map((c) => DropdownMenuItem<String>(
                              value: c['id'].toString(),
                              child: Text(c['nome'] ?? c['endereco'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => comodoId = v),
                    decoration: const InputDecoration(labelText: 'Cômodo'),
                    validator: (v) => v == null ? 'Selecione um cômodo' : null,
                  ),
                  const SizedBox(height: 12),
                  if (!criandoTipo)
                    DropdownButtonFormField<String>(
                      value: tipoId,
                      items: [
                        ...tipos.map((t) => DropdownMenuItem(
                              value: t['id'],
                              child: Text(t['nome']),
                            )),
                        const DropdownMenuItem(
                          value: 'novo',
                          child: Text('Adicionar novo tipo...'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == 'novo') {
                          setStateDialog(() {
                            criandoTipo = true;
                            tipoId = null;
                          });
                        } else {
                          setStateDialog(() => tipoId = v);
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Tipo de dispositivo'),
                      validator: (v) => v == null ? 'Selecione um tipo' : null,
                    ),
                  if (criandoTipo)
                    Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Nome do novo tipo'),
                          onChanged: (v) => tipoNomeNovo = v,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Informe o nome do tipo'
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (tipoNomeNovo != null &&
                                    tipoNomeNovo!.isNotEmpty) {
                                  // Verifica se já existe tipo com esse nome
                                  final tipoExistente = tipos.firstWhere(
                                    (t) =>
                                        (t['nome'] as String)
                                            .trim()
                                            .toLowerCase() ==
                                        tipoNomeNovo!.trim().toLowerCase(),
                                    orElse: () => {},
                                  );
                                  if (tipoExistente.isNotEmpty) {
                                    // Já existe, apenas seleciona
                                    setStateDialog(() {
                                      criandoTipo = false;
                                      tipoId = tipoExistente['id'];
                                    });
                                  } else {
                                    // Não existe, pode criar
                                    final uuid = const Uuid();
                                    final now = DateTime.now()
                                        .toUtc()
                                        .toIso8601String();
                                    final tipoJson = {
                                      'id': uuid.v4(),
                                      'createdAt': now,
                                      'nome': tipoNomeNovo,
                                    };
                                    final api = ApiService();
                                    await api.addTipoDispositivo(tipoJson);
                                    tipos = await api.listarTiposDispositivo();
                                    setStateDialog(() {
                                      criandoTipo = false;
                                      tipoId = tipoJson['id'];
                                    });
                                  }
                                }
                              },
                              child: const Text('Salvar tipo'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () =>
                                  setStateDialog(() => criandoTipo = false),
                              child: const Text('Cancelar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: ligado,
                    onChanged: (v) => setStateDialog(() => ligado = v),
                    title: const Text('Ligado'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    comodoId != null &&
                    tipoId != null) {
                  final uuid = const Uuid();
                  final now = DateTime.now().toUtc().toIso8601String();
                  final tipo = tipos.firstWhere((t) => t['id'] == tipoId);
                  final dispositivoJson = {
                    'id': uuid.v4(),
                    'createdAt': now,
                    'nome': nomeController.text.trim(),
                    'tipoDispositivoId': tipoId,
                    'comodoId': comodoId,
                    'ligado': ligado,
                    'tipoDispositivo': tipo,
                  };
                  final api = ApiService();
                  await api.addDispositivo(dispositivoJson);
                  if (mounted) {
                    Navigator.pop(context);
                    await _loadDevices();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Dispositivo adicionado com sucesso!'),
                          backgroundColor: Colors.green),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDevices,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
              ? Center(child: Text('Nenhum dispositivo cadastrado'))
              : ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return ListTile(
                      leading: const Icon(Icons.devices),
                      title: Text(device['nome'] ?? device['name'] ?? ''),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarDispositivo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
