class Validators {
  static String? validateRequired(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatorio';
    }
    return null;
  }

  static String? validateEmail(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  static String? validatePassword(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? validateCPF(final String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    final String cpf = value.replaceAll(RegExp('[^0-9]'), '');

    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    if (!_isValidCPF(cpf)) {
      return 'CPF inválido';
    }

    return null;
  }

  static String? validateName(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório!';
    }
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres!';
    }
    if (value.split(' ').length < 2) {
      return 'Nome deve ter ao menos um sobrenome!';
    }
    return null;
  }

  static String? validateConfirmPassword(
    final String? value,
    final String? password,
  ) {
    if (value == null || password == null) {
      return 'Confirmação de senha é obrigatória!';
    }
    if (value != password) {
      return 'Senhas não coincidem!';
    }
    return null;
  }

  static String? validateBirthDate(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Data de Nascimento é obrigatória!';
    }

    final String numbers = value.replaceAll(RegExp('[^0-9]'), '');

    if (numbers.length != 8) {
      return 'Data deve ter dia, mês e ano';
    }

    final int day = int.tryParse(numbers.substring(0, 2)) ?? 0;
    final int month = int.tryParse(numbers.substring(2, 4)) ?? 0;
    final int year = int.tryParse(numbers.substring(4, 8)) ?? 0;

    if (day < 1 || day > 31) {
      return 'Dia inválido';
    }

    if (month < 1 || month > 12) {
      return 'Mês inválido';
    }

    final int currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      return 'Ano inválido';
    }

    try {
      final date = DateTime(year, month, day);
      if (date.day != day || date.month != month || date.year != year) {
        return 'Data inválida';
      }

      if (date.isAfter(DateTime.now())) {
        return 'Data não pode ser no futuro';
      }
    } on Exception catch (_) {
      return 'Data inválida';
    }
    return null;
  }

  static String? validatePhone(final String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final String phone = value.replaceAll(RegExp('[^0-9]'), '');

    if (phone.length < 10 || phone.length > 11) {
      return 'Telefone deve ter 10 ou 11 digitos';
    }

    return null;
  }

  static String? validateResetPassToken(final String? value) {
    if (value == null || value.isEmpty) {
      return 'Código é obrigatório';
    }

    if (value.length < 6) {
      return 'Código deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? validateState(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Estado é obrigatório';
    }
    if (value.trim().length != 2) {
      return 'Estado deve ter 2 caracteres';
    }
    return null;
  }

  static String? validateZipCode(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CEP é obrigatório';
    }
    final String cleanValue = value.replaceAll(RegExp('[^0-9]'), '');
    if (cleanValue.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    return null;
  }

  static String? validateRequiredNumber(final String? value) {
    final String? requiredValueValidation = validateRequired(value);
    if (requiredValueValidation != null) {
      return requiredValueValidation;
    }
    if (int.tryParse(value!) == null) {
      return 'O valor não é um número';
    }
    return null;
  }

  static String formatCPF(final String cpf) {
    final String numbers = cpf.replaceAll(RegExp('[^0-9]'), '');

    final String limitedNumbers = numbers.length > 11
        ? numbers.substring(0, 11)
        : numbers;

    if (limitedNumbers.length <= 3) {
      return limitedNumbers;
    }
    if (limitedNumbers.length <= 6) {
      return '${limitedNumbers.substring(0, 3)}.${limitedNumbers.substring(3)}';
    }
    if (limitedNumbers.length <= 9) {
      return '${limitedNumbers.substring(0, 3)}.'
          '${limitedNumbers.substring(3, 6)}.'
          '${limitedNumbers.substring(6)}';
    }

    return '${limitedNumbers.substring(0, 3)}.'
        '${limitedNumbers.substring(3, 6)}.'
        '${limitedNumbers.substring(6, 9)}-'
        '${limitedNumbers.substring(9)}';
  }

  static String formatBirthDate(final String birthDate) {
    final String numbers = birthDate.replaceAll('[^0-9]', '');

    final String limitedNumbers = numbers.length > 8
        ? numbers.substring(0, 8)
        : numbers;

    if (limitedNumbers.length <= 2) {
      return limitedNumbers;
    }
    if (limitedNumbers.length <= 4) {
      return '${limitedNumbers.substring(0, 2)}/${limitedNumbers.substring(2)}';
    }

    return '${limitedNumbers.substring(0, 2)}/'
        '${limitedNumbers.substring(2, 4)}/'
        '${limitedNumbers.substring(4)}';
  }

  static String formatPhone(final String phone) {
    final String numbers = phone.replaceAll(RegExp('[^0-9]'), '');

    final String limitedNumbers = numbers.length > 11
        ? numbers.substring(0, 11)
        : numbers;

    if (limitedNumbers.length <= 2) {
      return limitedNumbers;
    }
    if (limitedNumbers.length <= 6) {
      return '(${limitedNumbers.substring(0, 2)}) '
          '${limitedNumbers.substring(2)}';
    }
    if (limitedNumbers.length <= 10) {
      return '(${limitedNumbers.substring(0, 2)}) '
          '${limitedNumbers.substring(2, 6)}-'
          '${limitedNumbers.substring(6)}';
    }

    return '(${limitedNumbers.substring(0, 2)}) '
        '${limitedNumbers.substring(2, 7)}-'
        '${limitedNumbers.substring(7)}';
  }

  static bool _isValidCPF(final String cpf) {
    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) {
      firstDigit = 0;
    }

    if (int.parse(cpf[9]) != firstDigit) {
      return false;
    }

    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) {
      secondDigit = 0;
    }

    return int.parse(cpf[10]) == secondDigit;
  }
}
