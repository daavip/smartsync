import 'package:flutter/material.dart';
import '../widgets/main_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      bottomNavigationBar: const MainNavigation(currentIndex: 2),
      body: const Center(child: Text('Tela de Configurações')),
    );
  }
}