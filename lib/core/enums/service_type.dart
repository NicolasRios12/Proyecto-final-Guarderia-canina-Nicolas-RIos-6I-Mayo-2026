/// Tipos de servicio disponibles en Dog Club.
enum ServiceType {
  hospedaje,
  guarderia,
  paseo;

  /// Convierte un string de Firestore al enum.
  static ServiceType fromString(String value) =>
    ServiceType.values.firstWhere((e) => e.name == value,
      orElse: () => ServiceType.guarderia);

  /// Devuelve el valor string para Firestore.
  String get toValue => name;

  /// Etiqueta legible para la UI.
  String get label {
    const labels = {
      ServiceType.hospedaje: 'Hospedaje',
      ServiceType.guarderia: 'Guardería',
      ServiceType.paseo: 'Paseo',
    };
    return labels[this] ?? name;
  }

  /// Emoji representativo del servicio.
  String get emoji {
    const emojis = {
      ServiceType.hospedaje: '🏠',
      ServiceType.guarderia: '👥',
      ServiceType.paseo: '🦮',
    };
    return emojis[this] ?? '🐾';
  }
}
