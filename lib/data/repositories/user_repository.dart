import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user_model.dart';

/// Repositorio para operaciones CRUD de usuarios en Firestore.
class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene un usuario por UID.
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  /// Stream de un usuario específico.
  Stream<UserModel?> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    });
  }

  /// Stream de todos los cuidadores activos.
  Stream<List<UserModel>> getCaregivers() {
    return _db
        .collection('users')
        .where('rol', isEqualTo: 'cuidador')
        .where('activo', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data(), d.id))
            .toList());
  }

  /// Stream de todos los usuarios (para admin).
  Stream<List<UserModel>> getAllUsers() {
    return _db
        .collection('users')
        .orderBy('fecha_registro', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap(d.data(), d.id))
            .toList());
  }

  /// Actualiza campos de un usuario o lo crea si no existe.
  Future<void> updateUser(UserModel user) async {
    try {
      await _db
          .collection('users')
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  /// Elimina un usuario de Firestore (no elimina de Auth).
  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }
}
