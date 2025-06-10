import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import '../../../../data/providers/room_provider.dart';
import '../../../../core/widgets/room_card.dart';
import 'room_edit_screen.dart';
import 'room_detail_screen.dart';
import '../../../../data/models/room_model.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Map<String, dynamic>> _rooms = [];
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
    _loadRooms();
  }

  Future<void> _carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioId = prefs.getString('usuario_id');
    });
    await _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() => _isLoading = true);
    if (_usuarioId != null) {
      final api = ApiService();
      final lista = await api.listarComodosPorUsuario(_usuarioId!);
      setState(() {
        _rooms = lista;
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cômodos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRooms,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.room_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum cômodo cadastrado',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toque no botão + para adicionar um cômodo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    return RoomCard(
                      name: room['nome'] ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RoomDetailScreen(roomId: room['id']),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomEditScreen(
                                room: Room(
                                    id: room['id'], name: room['nome'] ?? '')),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoomEditScreen(
                room: Room(
                  id: '',
                  name: '',
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
