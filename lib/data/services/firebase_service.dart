import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Servicio centralizado para acceder a las instancias de Firebase.
/// Evita crear múltiples instancias dispersas en el código.
class FirebaseService {
  FirebaseService._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Stream de cambios de autenticación.
  static Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Usuario actual de Firebase Auth.
  static User? get currentUser => auth.currentUser;
}
