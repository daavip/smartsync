import '../models/room_model.dart';

class RoomRepository {
  final List<Room> _rooms = [];

  Future<List<Room>> getAllRooms() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    return _rooms;
  }

  Future<Room> getRoomById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _rooms.firstWhere(
      (room) => room.id == id,
      orElse: () => throw Exception('Room with id $id not found'),
    );
  }

  Future<void> addRoom(Room room) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _rooms.add(room);
  }

  Future<void> updateRoom(Room updatedRoom) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _rooms.indexWhere((r) => r.id == updatedRoom.id);
    if (index != -1) {
      _rooms[index] = updatedRoom;
    }
  }

  Future<void> deleteRoom(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _rooms.removeWhere((room) => room.id == id);
  }
}