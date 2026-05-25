import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de reseña de un cuidador.
/// Colección Firestore: `reviews`.
class ReviewModel {
  final String id;
  final String caregiverUid;
  final String clientUid;
  final String clientNombre;
  final double rating;
  final String comentario;
  final DateTime fecha;

  const ReviewModel({
    required this.id,
    required this.caregiverUid,
    required this.clientUid,
    required this.clientNombre,
    required this.rating,
    required this.comentario,
    required this.fecha,
  });

  /// Crea un ReviewModel desde un mapa de Firestore.
  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) {
    return ReviewModel(
      id: id,
      caregiverUid: map['caregiver_uid'] as String? ?? '',
      clientUid: map['client_uid'] as String? ?? '',
      clientNombre: map['client_nombre'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comentario: map['comentario'] as String? ?? '',
      fecha: map['fecha'] is Timestamp
          ? (map['fecha'] as Timestamp).toDate()
          : DateTime.tryParse(map['fecha']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caregiver_uid': caregiverUid,
      'client_uid': clientUid,
      'client_nombre': clientNombre,
      'rating': rating,
      'comentario': comentario,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  /// Crea una copia del modelo con campos modificados.
  ReviewModel copyWith({
    String? id,
    String? caregiverUid,
    String? clientUid,
    String? clientNombre,
    double? rating,
    String? comentario,
    DateTime? fecha,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      caregiverUid: caregiverUid ?? this.caregiverUid,
      clientUid: clientUid ?? this.clientUid,
      clientNombre: clientNombre ?? this.clientNombre,
      rating: rating ?? this.rating,
      comentario: comentario ?? this.comentario,
      fecha: fecha ?? this.fecha,
    );
  }
}
