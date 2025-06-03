import '../models/room_model.dart';
import '../../core/services/storage_service.dart';

class RoomRepository {
  static const String _roomsKey = 'rooms';
  List<Room> _rooms = [];
  late StorageService _storage;
  bool _initialized = false;

  Future<void> _init() async {
    if (!_initialized) {
      _storage = await StorageService.getInstance();
      await _loadRoomsFromStorage();
      _initialized = true;
    }
  }

  Future<void> _loadRoomsFromStorage() async {
    final roomsData = _storage.getObjectList(_roomsKey);
    if (roomsData != null) {
      _rooms = roomsData.map((json) => Room.fromJson(json)).toList();
    }
  }

  Future<void> _saveRoomsToStorage() async {
    final roomsData = _rooms.map((room) => room.toJson()).toList();
    await _storage.saveObjectList(_roomsKey, roomsData);
  }

  Future<List<Room>> getAllRooms() async {
    await _init();
    return _rooms;
  }

  Future<Room> getRoomById(String id) async {
    await _init();
    return _rooms.firstWhere(
      (room) => room.id == id,
      orElse: () => throw Exception('Room with id $id not found'),
    );
  }

  Future<void> addRoom(Room room) async {
    await _init();
    final newRoom = room.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _rooms.add(newRoom);
    await _saveRoomsToStorage();
  }

  Future<void> updateRoom(Room updatedRoom) async {
    await _init();
    final index = _rooms.indexWhere((r) => r.id == updatedRoom.id);
    if (index != -1) {
      _rooms[index] = updatedRoom;
      await _saveRoomsToStorage();
    }
  }

  Future<void> deleteRoom(String id) async {
    await _init();
    _rooms.removeWhere((room) => room.id == id);
    await _saveRoomsToStorage();
  }
}