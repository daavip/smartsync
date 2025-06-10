import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _usuarioId;
  String? _usuarioNome;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioId = prefs.getString('usuario_id');
      _usuarioNome = prefs.getString('usuario_nome');
    });
  }

  Future<void> _salvarUsuario(String id, String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_id', id);
    await prefs.setString('usuario_nome', nome);
    setState(() {
      _usuarioId = id;
      _usuarioNome = nome;
    });
  }

  Future<bool> _validarUsuario(String id, String nome, String email) async {
    try {
      final usuario = await ApiService().buscarUsuarioPorId(id);
      if (usuario != null &&
          usuario['nome'] == nome &&
          usuario['email'] == email) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _buscarUsuarioPorNomeEmail(String nome, String email) async {
    try {
      final usuario = await ApiService().buscarUsuarioPorNomeEmail(nome, email);
      if (usuario != null &&
          usuario['nome'] == nome &&
          usuario['email'] == email) {
        return usuario['id'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _criarConta(BuildContext context) async {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Conta'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o e-mail' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final uuid = const Uuid();
                  final now = DateTime.now().toUtc().toIso8601String();
                  final usuario = {
                    'id': uuid.v4(),
                    'createdAt': now,
                    'nome': nomeController.text.trim(),
                    'email': emailController.text.trim(),
                    'residencias': [],
                  };
                  await ApiService().criarUsuario(usuario);
                  await _salvarUsuario(
                      usuario['id'].toString(), usuario['nome'].toString());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Conta criada com sucesso!'),
                          backgroundColor: Colors.green),
                    );
                  }
                  Navigator.pop(context, true);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao criar conta: $e'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
              }
            },
            child: const Text('Criar Conta'),
          ),
        ],
      ),
    );
  }

  Future<void> _entrarConta(BuildContext context) async {
    final nomeController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Entrar em uma Conta'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o e-mail' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final id = await _buscarUsuarioPorNomeEmail(
                  nomeController.text.trim(),
                  emailController.text.trim(),
                );
                if (id != null) {
                  await _salvarUsuario(id, nomeController.text.trim());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Login realizado com sucesso!'),
                          backgroundColor: Colors.green),
                    );
                  }
                  Navigator.pop(context, true);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Usuário não encontrado ou dados incorretos.'),
                          backgroundColor: Colors.red),
                    );
                  }
                }
              }
            },
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario_id');
    await prefs.remove('usuario_nome');
    setState(() {
      _usuarioId = null;
      _usuarioNome = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: _usuarioId == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_add,
                              size: 48, color: Theme.of(context).primaryColor),
                          const SizedBox(height: 16),
                          Text(
                            'Crie uma conta ou entre',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Salve seus dados e acesse de qualquer lugar',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.person_add),
                              label: const Text('Criar conta'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _criarConta(context),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Entrar em uma conta'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _entrarConta(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person,
                              size: 48, color: Theme.of(context).primaryColor),
                          const SizedBox(height: 16),
                          Text(
                            'Olá, $_usuarioNome!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Você está logado e seus dados estão salvos.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.logout),
                              label: const Text('Sair'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _logout,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
