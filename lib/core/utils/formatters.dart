/// Formateadores de texto para la UI.
class Formatters {
  Formatters._();

  /// Formatea un monto como moneda sin decimales.
  static String currency(double amount) =>
    '\$${amount.toStringAsFixed(0)}';

  /// Formatea el tamaño de mascota a texto legible.
  static String petSize(String tamanio) {
    const map = {
      'pequeño': 'Pequeño',
      'mediano': 'Mediano',
      'grande': 'Grande',
    };
    return map[tamanio] ?? tamanio;
  }
}
