import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repositorio de autenticación.
/// Maneja login, registro y cierre de sesión con Firebase Auth + Firestore.
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Login con email y contraseña.
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Registro: crea usuario en Auth y documento en Firestore.
  /// Si el email es admin@dogclub.com, asigna rol 'admin' automáticamente.
  Future<UserCredential> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Determinar rol automáticamente
      final isCaregiver = email.endsWith('@dogclub.com') &&
          (email.startsWith('paola') ||
              email.startsWith('diana') ||
              email.startsWith('carlos') ||
              email.contains('cuidador'));
      final rol = email == 'admin@dogclub.com'
          ? 'admin'
          : isCaregiver
              ? 'cuidador'
              : 'cliente';

      // Crear documento en Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'direccion': '',
        'rol': rol,
        'foto_url': '',
        'bio': '',
        'fecha_registro': Timestamp.now(),
        'activo': true,
      });

      return credential;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Cierre de sesión.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Stream de cambios de autenticación.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Obtener usuario actual de Firebase Auth.
  User? get currentUser => _auth.currentUser;
}
