import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../repositories/room_repository.dart';

class RoomProvider with ChangeNotifier {
  final RoomRepository _repository = RoomRepository();
  List<Room> _rooms = [];
  bool _isLoading = false;

  RoomProvider() {
    loadRooms();
  }

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  Future<void> loadRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _rooms = await _repository.getAllRooms();
    } catch (e) {
      debugPrint('Erro ao carregar cômodos: $e');
      _rooms = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRoom(Room room) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.addRoom(room);
      await loadRooms();
    } catch (e) {
      debugPrint('Erro ao adicionar cômodo: $e');
      rethrow;
    }
  }

  Future<void> updateRoom(Room room) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateRoom(room);
      await loadRooms();
    } catch (e) {
      debugPrint('Erro ao atualizar cômodo: $e');
      rethrow;
    }
  }

  Future<void> deleteRoom(String roomId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.deleteRoom(roomId);
      await loadRooms();
    } catch (e) {
      debugPrint('Erro ao deletar cômodo: $e');
      rethrow;
    }
  }

  String getRoomNameById(String roomId) {
    try {
      return _rooms.firstWhere((room) => room.id == roomId).name;
    } catch (e) {
      return 'Desconhecido';
    }
  }
}
