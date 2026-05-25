import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../core/models/pet_model.dart';

/// Repositorio para operaciones CRUD de mascotas en Firestore.
class PetRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Agrega una mascota a Firestore.
  Future<void> addPet(PetModel pet) async {
    try {
      await _db.collection('pets').doc(pet.id).set(pet.toMap());
    } catch (e) {
      throw Exception('Error al agregar mascota: $e');
    }
  }

  /// Stream de mascotas del usuario, ordenadas por fecha de creación.
  Stream<List<PetModel>> getUserPets(String ownerUid) {
    return _db
        .collection('pets')
        .where('owner_uid', isEqualTo: ownerUid)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => PetModel.fromMap(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        });
  }

  /// Stream de todas las mascotas (para admin).
  Stream<List<PetModel>> getAllPets() {
    return _db
        .collection('pets')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => PetModel.fromMap(d.data(), d.id))
            .toList());
  }

  /// Actualiza el estado de una mascota ('disponible' o 'en_servicio').
  /// Si el usuario no tiene permisos (por ejemplo, porque el cuidador no es dueño
  /// de la mascota y las reglas de Firebase lo prohíben), se captura el error de permisos
  /// para evitar bloquear el flujo principal de confirmación de reservas.
  Future<void> updateStatus(String petId, String estado) async {
    try {
      await _db.collection('pets').doc(petId).update({'estado': estado});
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('permission-denied') ||
          errorStr.contains('permission_denied') ||
          errorStr.contains('permission denied')) {
        debugPrint(
            '⚠️ Advertencia: Permiso denegado para actualizar estado de la mascota ($petId) a ($estado). Omitiendo debido a reglas de seguridad.');
        return;
      }
      throw Exception('Error al actualizar estado de mascota: $e');
    }
  }

  /// Actualiza todos los campos de una mascota.
  Future<void> updatePet(PetModel pet) async {
    try {
      await _db.collection('pets').doc(pet.id).update(pet.toMap());
    } catch (e) {
      throw Exception('Error al actualizar mascota: $e');
    }
  }

  /// Elimina una mascota solo si no tiene reservas activas.
  /// Devuelve true si se eliminó, false si tiene reservas activas.
  Future<bool> deletePet(String petId) async {
    try {
      // Verificar reservas activas
      final activeBookings = await _db
          .collection('bookings')
          .where('pet_id', isEqualTo: petId)
          .where('estado', whereIn: ['pendiente', 'confirmada', 'en_curso'])
          .get();

      if (activeBookings.docs.isNotEmpty) return false;

      await _db.collection('pets').doc(petId).delete();
      return true;
    } catch (e) {
      throw Exception('Error al eliminar mascota: $e');
    }
  }
}
