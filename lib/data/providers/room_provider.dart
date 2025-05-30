import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../repositories/room_repository.dart';

class RoomProvider with ChangeNotifier {
  final RoomRepository _repository = RoomRepository();
  List<Room> _rooms = [];
  bool _isLoading = false;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  Future<void> loadRooms() async {
    _isLoading = true;
    notifyListeners();

    _rooms = await _repository.getAllRooms();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRoom(Room room) async {
    _isLoading = true;
    notifyListeners();

    await _repository.addRoom(room);
    await loadRooms();
  }

  Future<void> updateRoom(Room room) async {
    _isLoading = true;
    notifyListeners();

    await _repository.updateRoom(room);
    await loadRooms();
  }

  Future<void> deleteRoom(String roomId) async {
    _isLoading = true;
    notifyListeners();

    await _repository.deleteRoom(roomId);
    await loadRooms();
  }

  String getRoomNameById(String roomId) {
    try {
      return _rooms.firstWhere((room) => room.id == roomId).name;
    } catch (e) {
      return 'Desconhecido';
    }
  }
}