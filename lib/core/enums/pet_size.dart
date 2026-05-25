/// Tamaños de mascota.
enum PetSize {
  pequenio,
  mediano,
  grande;

  /// Convierte un string de Firestore al enum.
  static PetSize fromString(String v) {
    const map = {
      'pequeño': PetSize.pequenio,
      'mediano': PetSize.mediano,
      'grande': PetSize.grande,
    };
    return map[v] ?? PetSize.mediano;
  }

  /// Devuelve el valor string para Firestore.
  String get toValue {
    const map = {
      PetSize.pequenio: 'pequeño',
      PetSize.mediano: 'mediano',
      PetSize.grande: 'grande',
    };
    return map[this]!;
  }

  /// Etiqueta legible para la UI.
  String get label {
    const labels = {
      PetSize.pequenio: 'Pequeño',
      PetSize.mediano: 'Mediano',
      PetSize.grande: 'Grande',
    };
    return labels[this]!;
  }
}
