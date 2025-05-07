import 'package:flutter/material.dart';
import '../screens/devices_screens.dart';
import '../screens/rooms_screen.dart';
import '../screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final int currentIndex;

  const MainNavigation({super.key, required this.currentIndex});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DevicesScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoomsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: _onTabTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Dispositivos'),
        BottomNavigationBarItem(icon: Icon(Icons.room), label: 'Cômodos'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configurações'),
      ],
    );
  }
}