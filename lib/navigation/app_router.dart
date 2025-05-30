// import 'package:flutter/material.dart';
// import '../features/devices/screens/devices_screen.dart';
// import '../features/rooms/screens/rooms_screen.dart';
// import '../features/settings/screens/settings_screen.dart';

// class AppRouter {
//   static const String devices = 'devices';
//   static const String rooms = 'rooms';
//   static const String settings = 'settings';

//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case AppRouter.devices:
//         return MaterialPageRoute(builder: (_) => const DevicesScreen());
//       case AppRouter.rooms:
//         return MaterialPageRoute(builder: (_) => const RoomsScreen());
//       case AppRouter.settings:
//         return MaterialPageRoute(builder: (_) => const SettingsScreen());
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(
//               child: Text('No route defined for ${settings.name}'),
//             ),
//           ),
//         );
//     }
//   }

//   static Map<String, WidgetBuilder> get routes {
//     return {
//       devices: (context) => const DevicesScreen(),
//       rooms: (context) => const RoomsScreen(),
//       settings: (context) => const SettingsScreen(),
//     };
//   }
// }