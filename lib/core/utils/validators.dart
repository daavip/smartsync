class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome não pode ser vazio';
    }
    if (value.length < 2) {
      return 'Nome muito curto';
    }
    return null;
  }

  static String? validateRoom(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecione um cômodo';
    }
    return null;
  }
}