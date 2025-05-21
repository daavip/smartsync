class SettingsController {
  bool darkMode = false;

  void toggleDarkMode(bool value) {
    darkMode = value;
    print('Modo escuro: $darkMode');
  }
}