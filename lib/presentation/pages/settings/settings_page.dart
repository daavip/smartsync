import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SettingsOptionTile(title: 'Tema Escuro'),
          SettingsOptionTile(title: 'Notificações'),
        ],
      ),
    );
  }
}

class SettingsOptionTile extends StatelessWidget {
  final String title;

  SettingsOptionTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: true,
      onChanged: (value) {},
    );
  }
}
