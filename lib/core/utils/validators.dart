/// Validadores de formularios.
/// Todos los mensajes están en español.
class Validators {
  Validators._();

  /// Valida un correo electrónico.
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'El correo es requerido';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  /// Valida una contraseña (mínimo 6 caracteres).
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es requerida';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  /// Valida que la confirmación coincida con la contraseña.
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirma tu contraseña';
    if (value != password) return 'Las contraseñas no coinciden';
    return null;
  }

  /// Valida que un campo no esté vacío.
  static String? required(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.trim().isEmpty) return '$fieldName es requerido';
    return null;
  }

  /// Valida un número de teléfono (opcional, pero si tiene valor debe tener 10+ chars).
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length < 10) return 'Teléfono inválido';
    return null;
  }

  /// Valida un peso numérico.
  static String? weight(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) return 'Ingresa un número válido';
    return null;
  }
}
