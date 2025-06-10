import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import '../../../../data/models/residence_model.dart';
// Importe o provider de residências quando criado

class ResidencesScreen extends StatefulWidget {
  const ResidencesScreen({super.key});

  @override
  State<ResidencesScreen> createState() => _ResidencesScreenState();
}

class _ResidencesScreenState extends State<ResidencesScreen> {
  List<Residencia> _residencias = [];
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
    _loadResidencias();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioId = prefs.getString('usuario_id');
    });
    await _loadResidencias();
  }

  Future<void> _loadResidencias() async {
    setState(() => _isLoading = true);
    if (_usuarioId != null) {
      final api = ApiService();
      final lista = await api.listarResidenciasPorUsuario(_usuarioId!);
      setState(() {
        _residencias = lista.map((res) => Residencia(
          id: res['id'],
          name: res['endereco'],
        )).toList();
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _adicionarResidencia() async {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Residência'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration:
                const InputDecoration(labelText: 'Endereço da residência'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe o endereço' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && _usuarioId != null) {
      setState(() => _isLoading = true);
      try {
        final api = ApiService();
        final uuid = const Uuid();
        final now = DateTime.now().toUtc().toIso8601String();
        final residenciaJson = {
          'id': uuid.v4(),
          'createdAt': now,
          'endereco': result,
          'usuarioId': _usuarioId,
          'comodos': [],
        };
        final response = await api.addResidencia(residenciaJson);
        setState(() {
          _residencias.add(Residencia(
            id: response['id'],
            name: response['endereco'],
          ));
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Residência adicionada com sucesso!'),
                backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao adicionar residência: $e'),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    } else if (_usuarioId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Você precisa estar logado para adicionar uma residência.'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Residências'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResidencias,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _residencias.isEmpty
              ? Center(child: Text('Nenhuma residência cadastrada'))
              : ListView.builder(
                  itemCount: _residencias.length,
                  itemBuilder: (context, index) {
                    final residencia = _residencias[index];
                    return ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(residencia.name),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarResidencia,
        child: const Icon(Icons.add),
      ),
    );
  }
}
