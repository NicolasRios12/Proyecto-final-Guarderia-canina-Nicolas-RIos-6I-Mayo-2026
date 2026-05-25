import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/enums/booking_status.dart';
import '../../core/models/booking_model.dart';

/// Repositorio para operaciones CRUD de reservas en Firestore.
class BookingRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Crea una nueva reserva en Firestore.
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final docRef = _db.collection('bookings').doc(booking.id);
      await docRef.set(booking.toMap());
      return booking;
    } catch (e) {
      throw Exception('Error al crear reserva: $e');
    }
  }

  /// Stream de reservas del cliente, ordenadas por fecha de creación.
  Stream<List<BookingModel>> getClientBookings(String clientUid) {
    return _db
        .collection('bookings')
        .where('client_uid', isEqualTo: clientUid)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => BookingModel.fromMap(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// Stream de solicitudes pendientes para un cuidador.
  Stream<List<BookingModel>> getPendingForCaregiver(String caregiverUid) {
    return _db
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('estado', isEqualTo: 'pendiente')
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => BookingModel.fromMap(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// Stream de reservas activas del cuidador (confirmadas o en curso).
  Stream<List<BookingModel>> getActiveForCaregiver(String caregiverUid) {
    return _db
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .where('estado', whereIn: ['confirmada', 'en_curso'])
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => BookingModel.fromMap(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// Stream de todas las reservas de un cuidador (para ganancias, etc.).
  Stream<List<BookingModel>> getAllForCaregiver(String caregiverUid) {
    return _db
        .collection('bookings')
        .where('caregiver_uid', isEqualTo: caregiverUid)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => BookingModel.fromMap(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// Stream de todas las reservas (para admin).
  Stream<List<BookingModel>> getAllBookings() {
    return _db
        .collection('bookings')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => BookingModel.fromMap(d.data(), d.id))
            .toList());
  }

  /// Actualiza el estado de una reserva.
  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'estado': status.toValue,
      });
    } catch (e) {
      throw Exception('Error al actualizar estado de reserva: $e');
    }
  }

  /// Actualiza una reserva completa.
  Future<void> updateBooking(BookingModel booking) async {
    try {
      await _db.collection('bookings').doc(booking.id).update(booking.toMap());
    } catch (e) {
      throw Exception('Error al actualizar reserva: $e');
    }
  }

  /// Elimina una reserva.
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _db.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      throw Exception('Error al eliminar reserva: $e');
    }
  }
}
