import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/review_model.dart';

/// Repositorio para operaciones CRUD de reseñas en Firestore.
class ReviewRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Guarda una nueva reseña en Firestore.
  /// Usamos el ID de la reserva como ID de la reseña para evitar duplicados.
  Future<void> createReview(ReviewModel review) async {
    try {
      await _db.collection('reviews').doc(review.id).set(review.toMap());
    } catch (e) {
      throw Exception('Error al guardar la reseña: $e');
    }
  }

  /// Stream de todas las reseñas de un cuidador en específico.
  Stream<List<ReviewModel>> getCaregiverReviews(String caregiverUid) {
    return _db
        .collection('reviews')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => ReviewModel.fromMap(d.data(), d.id))
              .toList();
          // Ordenar por fecha descendente
          list.sort((a, b) => b.fecha.compareTo(a.fecha));
          return list;
        });
  }

  /// Verifica si una reserva ya tiene reseña.
  Future<bool> hasReview(String bookingId) async {
    try {
      final doc = await _db.collection('reviews').doc(bookingId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
