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
      body:
          roomProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: roomProvider.rooms.length,
                itemBuilder: (context, index) {
                  final room = roomProvider.rooms[index];
                  return RoomCard(
                    name: room.name,
                    deviceCount: room.deviceIds.length,
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
              builder:
                  (_) => RoomEditScreen(
                    room: Room(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: 'Novo Cômodo',
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
