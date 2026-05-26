import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../core/enums/user_role.dart';
import '../../core/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/seed_service.dart';

/// Provider de autenticación y perfil de usuario.
/// Maneja login, registro, logout, y carga del perfil desde Firestore.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  final UserRepository _userRepo = UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  UserRole? get role => _currentUser?.rol;

  /// Inicializa el provider: verifica si hay sesión activa y carga el perfil.
  Future<void> initialize() async {
    try {
      final user = _authRepo.currentUser;
      if (user != null) {
        await loadUserProfile(user.uid);
      }
    } catch (e) {
      debugPrint('Error al inicializar auth: $e');
    }
  }

  /// Inicia sesión con email y contraseña.
  /// Devuelve true si el login fue exitoso.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authRepo.signIn(email, password);
      await loadUserProfile(credential.user!.uid);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Registra un nuevo usuario y crea su documento en Firestore.
  /// Devuelve true si el registro fue exitoso.
  Future<bool> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepo.register(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
      );

      // Cerrar sesión después de registrar para que inicie sesión manualmente
      await _authRepo.signOut();

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cierra la sesión actual y limpia el estado.
  Future<void> logout() async {
    try {
      await _authRepo.signOut();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión: $e';
      notifyListeners();
    }
  }

  /// Carga el perfil del usuario desde Firestore.
  Future<void> loadUserProfile(String uid) async {
    try {
      // Intentar sembrar la base de datos de manera segura ahora que estamos autenticados
      await _seedIfNeeded();

      var user = await _userRepo.getUser(uid);
      if (user == null) {
        // Si el usuario existe en Firebase Auth pero no en Firestore (ej. creado en Firebase Console),
        // inicializar el documento de Firestore de forma inteligente.
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          final email = firebaseUser.email ?? '';
          
          // Determinar rol y datos basados en el email
          String rol = 'cliente';
          String nombre = '';
          String apellido = 'Usuario';
          String telefono = '';
          String direccion = 'Juárez, Chihuahua';
          String fotoUrl = '';
          String backgroundImg = '';
          String bio = '';
          
          if (email == 'admin@dogclub.com') {
            rol = 'admin';
            nombre = 'Administrador';
            apellido = 'Dog Club';
            telefono = '+52 656 000 0000';
            bio = 'Administrador del sistema Dog Club';
          } else if (email == 'paola.martinez@dogclub.com') {
            rol = 'cuidador';
            nombre = 'Paola';
            apellido = 'Martinez';
            telefono = '+52 656 123 4567';
            fotoUrl = 'https://i.pravatar.cc/150?img=1';
            backgroundImg = 'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&q=80&w=600';
            bio = 'Amante de los perros con 5 años de experiencia. Sin mascotas propias. Casa con jardín.';
          } else if (email == 'diana.juarez@dogclub.com') {
            rol = 'cuidador';
            nombre = 'Diana';
            apellido = 'Juarez';
            telefono = '+52 656 987 6543';
            fotoUrl = 'https://i.pravatar.cc/150?img=5';
            backgroundImg = 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&q=80&w=600';
            bio = 'Cuidadora certificada, veterinaria en formación. Experiencia con todas las razas.';
          } else if (email == 'carlos.lopez@dogclub.com') {
            rol = 'cuidador';
            nombre = 'Carlos';
            apellido = 'Lopez';
            telefono = '+52 656 555 7890';
            fotoUrl = 'https://i.pravatar.cc/150?img=12';
            backgroundImg = 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&q=80&w=600';
            bio = 'Especialista en paseos y entrenamiento básico. Disponible todos los días.';
          } else if (email == 'cliente1@dogclub.com') {
            rol = 'cliente';
            nombre = 'María';
            apellido = 'García';
            telefono = '+52 656 111 2222';
            fotoUrl = 'https://i.pravatar.cc/150?img=25';
          } else {
            // Fallback general
            final isCaregiver = email.endsWith('@dogclub.com') && 
                (email.startsWith('paola') || email.startsWith('diana') || email.startsWith('carlos') || email.contains('cuidador'));
            rol = isCaregiver ? 'cuidador' : 'cliente';
            nombre = email.split('@').first;
            if (nombre.isNotEmpty) {
              nombre = nombre.substring(0, 1).toUpperCase() + nombre.substring(1);
            }
          }
          
          user = UserModel(
            uid: uid,
            email: email,
            nombre: nombre,
            apellido: apellido,
            telefono: telefono,
            direccion: direccion,
            rol: UserRole.fromString(rol),
            fotoUrl: fotoUrl,
            backgroundImg: backgroundImg,
            bio: bio,
            fechaRegistro: DateTime.now(),
            activo: true,
          );
          
          // Crear/guardar documento en Firestore
          await _userRepo.updateUser(user);
          debugPrint('✅ Documento de usuario creado automáticamente en Firestore para $email con rol $rol');
        }
      }

      // Re-asociación inteligente de datos ficticios del seed (mascotas, reservas, chats) al UID real de Auth
      if (user != null) {
        await _reassociateMockData(user.email, uid);
      }

      _currentUser = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar perfil: $e');
    }
  }

  /// Re-asocia dinámicamente datos ficticios del seed ('cliente_maria', etc.) con el UID de Auth real.
  Future<void> _reassociateMockData(String email, String realUid) async {
    try {
      final mockUidMap = {
        'admin@dogclub.com': 'admin_dogclub',
        'paola.martinez@dogclub.com': 'cuidador_paola',
        'diana.juarez@dogclub.com': 'cuidador_diana',
        'carlos.lopez@dogclub.com': 'cuidador_carlos',
        'cliente1@dogclub.com': 'cliente_maria',
        'pedro.ortiz@dogclub.com': 'cliente_pedro',
      };

      final mockUid = mockUidMap[email];
      if (mockUid == null || mockUid == realUid) return;

      final db = FirebaseFirestore.instance;
      
      // 1. Re-asociar reservas como cuidador
      final bookingsAsCaregiver = await db
          .collection('bookings')
          .where('caregiver_uid', isEqualTo: mockUid)
          .get();
      for (final doc in bookingsAsCaregiver.docs) {
        await doc.reference.update({'caregiver_uid': realUid});
      }

      // 2. Re-asociar reservas como cliente
      final bookingsAsClient = await db
          .collection('bookings')
          .where('client_uid', isEqualTo: mockUid)
          .get();
      for (final doc in bookingsAsClient.docs) {
        await doc.reference.update({'client_uid': realUid});
      }

      // 3. Re-asociar mascotas
      final pets = await db
          .collection('pets')
          .where('owner_uid', isEqualTo: mockUid)
          .get();
      for (final doc in pets.docs) {
        await doc.reference.update({'owner_uid': realUid});
      }

      // 4. Re-asociar chats (en participantes)
      final chats = await db
          .collection('chats')
          .where('participants', arrayContains: mockUid)
          .get();
      for (final doc in chats.docs) {
        final participants = List<String>.from(doc.data()['participants'] ?? []);
        final idx = participants.indexOf(mockUid);
        if (idx != -1) {
          participants[idx] = realUid;
          await doc.reference.update({'participants': participants});
        }
      }
      
      debugPrint('🔗 Re-asociación inteligente exitosa para email: $email (Mapeado de $mockUid a $realUid)');
    } catch (e) {
      debugPrint('⚠️ Error en la re-asociación inteligente de datos: $e');
    }
  }

  /// Siembra los datos de prueba de manera segura si la base de datos está vacía.
  /// Se ejecuta con un usuario autenticado para evitar errores de permission-denied.
  Future<void> _seedIfNeeded() async {
    try {
      final db = FirebaseFirestore.instance;
      final servicesCount = await db.collection('services').count().get();
      final usersCount = await db.collection('users').count().get();
      if ((servicesCount.count ?? 0) == 0 || (usersCount.count ?? 0) == 0) {
        await SeedService.seedAll();
      }
    } catch (e) {
      debugPrint('⚠️ Advertencia en _seedIfNeeded dentro de AuthProvider: $e');
    }
  }

  /// Actualiza el perfil del usuario actual en memoria.
  void updateCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Limpia el mensaje de error.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Mapea códigos de error de Firebase Auth a mensajes en español.
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Este correo ya está registrado';
      case 'weak-password':
        return 'La contraseña debe tener mínimo 6 caracteres';
      case 'invalid-email':
        return 'El correo no es válido';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet';
      case 'invalid-credential':
        return 'Credenciales inválidas. Verifica tu correo y contraseña';
      default:
        return 'Error: ${e.message}';
    }
  }
}
