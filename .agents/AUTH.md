# AUTH.md — Lógica de Autenticación y Roles

## Flujo general de autenticación

```
App inicia
    │
    ▼
SplashScreen (2 segundos máximo)
    │
    ├── FirebaseAuth.instance.authStateChanges()
    │
    ├── Stream emite User? == null
    │       └──→ Navegar a /login
    │
    └── Stream emite User != null
            │
            └── Consultar users/{uid} en Firestore
                    │
                    ├── rol == 'cliente'   → /home
                    ├── rol == 'cuidador'  → /caregiver
                    └── rol == 'admin'     → /admin
```

---

## AuthProvider — `lib/presentation/providers/auth_provider.dart`

Estado que debe exponer:
```dart
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  UserRole? get role => _currentUser?.rol;
}
```

Métodos requeridos:
- `Future<void> initialize()` — escucha `authStateChanges`, carga perfil de Firestore
- `Future<bool> login(String email, String password)` — devuelve true si éxito
- `Future<bool> register({...todos los campos})` — crea auth + Firestore doc
- `Future<void> logout()` — cierra sesión, limpia estado
- `Future<void> loadUserProfile(String uid)` — carga datos de Firestore
- `void clearError()` — limpia mensaje de error

---

## AuthRepository — `lib/data/repositories/auth_repository.dart`

```dart
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Login con email/password
  Future<UserCredential> signIn(String email, String password);

  // Registro: crea auth user + documento Firestore
  Future<UserCredential> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
  });

  // Cierre de sesión
  Future<void> signOut();

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;
}
```

### Lógica especial de registro:

```dart
Future<UserCredential> register({...}) async {
  final credential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  // Determinar rol automáticamente
  final rol = email == 'admin@dogclub.com' ? 'admin' : 'cliente';

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
}
```

---

## Credenciales de prueba (hardcodeadas para demo)

| Rol      | Email                        | Password    |
|----------|------------------------------|-------------|
| Admin    | admin@dogclub.com            | admin123    |
| Cuidador | paola.martinez@dogclub.com   | password123 |
| Cuidador | diana.juarez@dogclub.com     | password123 |
| Cliente  | cliente1@dogclub.com         | password123 |

**Regla especial:** Si el email al registrarse es `admin@dogclub.com`,
asignar rol `'admin'` automáticamente en el documento Firestore.

---

## Manejo de errores de autenticación

Mapear TODOS estos códigos de Firebase a mensajes en español:

```dart
String _mapAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':      return 'Usuario no encontrado';
    case 'wrong-password':      return 'Contraseña incorrecta';
    case 'email-already-in-use':return 'Este correo ya está registrado';
    case 'weak-password':       return 'La contraseña debe tener mínimo 6 caracteres';
    case 'invalid-email':       return 'El correo no es válido';
    case 'user-disabled':       return 'Esta cuenta está deshabilitada';
    case 'too-many-requests':   return 'Demasiados intentos. Intenta más tarde';
    case 'network-request-failed': return 'Error de conexión. Verifica tu internet';
    default:                    return 'Error: ${e.message}';
  }
}
```

---

## Configuración de rutas por rol — `lib/config/routes.dart`

El router debe:
1. Usar `GoRouter` con `redirect` global
2. Consultar `AuthProvider` para saber si hay sesión
3. Redirigir según `rol` al hacer login
4. Proteger rutas `/home`, `/caregiver`, `/admin` — redirigen a `/login` si no hay sesión
5. Redirigir a la pantalla correcta si ya hay sesión y el usuario va a `/login`

```dart
final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final isLoggedIn = auth.isAuthenticated;
    final location = state.matchedLocation;

    // Si está en splash, no redirigir aún
    if (location == '/splash') return null;

    if (!isLoggedIn && location != '/login' && location != '/register') {
      return '/login';
    }

    if (isLoggedIn && (location == '/login' || location == '/register')) {
      switch (auth.role) {
        case UserRole.admin: return '/admin';
        case UserRole.cuidador: return '/caregiver';
        default: return '/home';
      }
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
    // ... (ver SCREENS.md para rutas completas)
  ],
);
```

---

## SplashScreen — Comportamiento exacto

```dart
class SplashScreen extends StatefulWidget { ... }

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Esperar mínimo 2 segundos para mostrar el logo
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      context.read<AuthProvider>().initialize(),
    ]);

    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      switch (auth.role) {
        case UserRole.admin:    context.go('/admin'); break;
        case UserRole.cuidador: context.go('/caregiver'); break;
        default:                context.go('/home');
      }
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E40AF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Dog Club — usar FlutterLogo o imagen de assets
            Icon(Icons.pets, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text('Dog Club',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
```
