class RoomsController {
  List<String> getRooms() {
    return ['Sala', 'Cozinha', 'Quarto'];
  }

  void addRoom(String roomName) {
    print('Cômodo adicionado: $roomName');
  }
}