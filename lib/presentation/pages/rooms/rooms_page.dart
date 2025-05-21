import 'package:flutter/material.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cômodos')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          RoomTile(name: 'Sala'),
          RoomTile(name: 'Cozinha'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddRoomDialog(),
        ),
      ),
    );
  }
}

class RoomTile extends StatelessWidget {
  final String name;

  RoomTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class AddRoomDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Cômodo'),
      content: Text('Formulário para adicionar cômodo aqui.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Adicionar'),
        ),
      ],
    );
  }
}
