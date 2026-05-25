/// Estados posibles de una reserva.
/// Ciclo: pendiente → confirmada → en_curso → completada
///                            ↘ cancelada
enum BookingStatus {
  pendiente,
  confirmada,
  enCurso,
  completada,
  cancelada;

  /// Convierte un string de Firestore al enum.
  static BookingStatus fromString(String value) {
    const map = {
      'pendiente': BookingStatus.pendiente,
      'confirmada': BookingStatus.confirmada,
      'en_curso': BookingStatus.enCurso,
      'completada': BookingStatus.completada,
      'cancelada': BookingStatus.cancelada,
    };
    return map[value] ?? BookingStatus.pendiente;
  }

  /// Devuelve el valor string para Firestore.
  String get toValue {
    const map = {
      BookingStatus.enCurso: 'en_curso',
    };
    return map[this] ?? name;
  }

  /// Etiqueta legible para la UI.
  String get label {
    const labels = {
      BookingStatus.pendiente: 'Pendiente',
      BookingStatus.confirmada: 'Confirmada',
      BookingStatus.enCurso: 'En Curso',
      BookingStatus.completada: 'Completada',
      BookingStatus.cancelada: 'Cancelada',
    };
    return labels[this] ?? name;
  }
}
