import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/providers/room_provider.dart';
import '../../../../core/widgets/room_card.dart';
import 'room_edit_screen.dart';
import 'room_detail_screen.dart';
import '../../../../data/models/room_model.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cômodos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: roomProvider.loadRooms,
          ),
        ],
      ),
      body: roomProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : roomProvider.rooms.isEmpty
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
                  itemCount: roomProvider.rooms.length,
                  itemBuilder: (context, index) {
                    final room = roomProvider.rooms[index];
                    return RoomCard(
                      name: room.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomDetailScreen(roomId: room.id),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomEditScreen(room: room),
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
