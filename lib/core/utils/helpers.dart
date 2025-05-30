class Helpers {
  static String formatDeviceName(String name) {
    if (name.length > 20) {
      return '${name.substring(0, 20)}...';
    }
    return name;
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}