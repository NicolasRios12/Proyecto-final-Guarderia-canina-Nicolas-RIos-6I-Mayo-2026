# FIREBASE.md — Configuración Firebase y Reglas de Seguridad

## Setup inicial (comandos)

```bash
# 1. Instalar Firebase CLI (si no está instalado)
npm install -g firebase-tools

# 2. Login en Firebase
firebase login

# 3. Configurar FlutterFire
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Instalar dependencias Flutter
flutter pub get
```

---

## firebase_options.dart — Template

Generar con `flutterfire configure`. El archivo debe tener esta estructura:

```dart
// lib/config/firebase_options.dart
// IMPORTANTE: Este archivo es generado automáticamente por FlutterFire CLI.
// Ejecutar: flutterfire configure
// NO subir al repositorio (agregar a .gitignore si contiene claves reales)

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS:     return ios;
      case TargetPlatform.macOS:   return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están configurados para esta plataforma. '
          'Ejecuta flutterfire configure para generar este archivo.',
        );
    }
  }

  // REEMPLAZAR con valores reales de Firebase Console
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TU_API_KEY',
    appId: 'TU_APP_ID',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    authDomain: 'TU_PROJECT.firebaseapp.com',
    storageBucket: 'TU_PROJECT.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY_ANDROID',
    appId: 'TU_APP_ID_ANDROID',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TU_API_KEY_IOS',
    appId: 'TU_APP_ID_IOS',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT.appspot.com',
    iosBundleId: 'com.example.dogClub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'TU_API_KEY_MACOS',
    appId: 'TU_APP_ID_MACOS',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT.appspot.com',
    iosBundleId: 'com.example.dogClub',
  );
}
```

---

## main.dart — Inicialización de Firebase

```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/pet_provider.dart';
import 'presentation/providers/booking_provider.dart';
import 'presentation/providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const DogClubApp());
}

class DogClubApp extends StatelessWidget {
  const DogClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp.router(
        title: 'Dog Club',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
```

---

## theme.dart — Material 3

```dart
// lib/config/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E40AF),
      primary: const Color(0xFF1E40AF),
      secondary: const Color(0xFF3B82F6),
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFF8FAFC),
      error: const Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      bodyLarge: GoogleFonts.inter(
        color: const Color(0xFF0F172A), fontSize: 16),
      bodyMedium: GoogleFonts.inter(
        color: const Color(0xFF0F172A), fontSize: 14),
      bodySmall: GoogleFonts.inter(
        color: const Color(0xFF475569), fontSize: 12),
      titleLarge: GoogleFonts.inter(
        color: const Color(0xFF0F172A),
        fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.inter(
        color: const Color(0xFF0F172A),
        fontSize: 18, fontWeight: FontWeight.w600),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E40AF),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 12),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF1E40AF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1E40AF),
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0), thickness: 1),
    chipTheme: ChipThemeData(
      selectedColor: const Color(0xFF1E40AF),
      labelStyle: const TextStyle(fontSize: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)),
    ),
  );
}
```

---

## Reglas de Seguridad Firestore — `firestore.rules`

### Para PRODUCCIÓN (reglas completas):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuthenticated() {
      return request.auth != null;
    }

    function hasRole(role) {
      return isAuthenticated() &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.rol == role;
    }

    function isOwner(uid) {
      return isAuthenticated() && request.auth.uid == uid;
    }

    // Usuarios
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isAuthenticated() &&
                       (request.auth.uid == userId || hasRole('admin'));
      allow delete: if hasRole('admin');

      match /pets/{petId} {
        allow read, write: if isOwner(userId);
      }
    }

    // Mascotas (colección raíz)
    match /pets/{petId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() &&
                       (resource.data.owner_uid == request.auth.uid ||
                        hasRole('admin'));
      allow delete: if hasRole('admin');
    }

    // Servicios (solo admin escribe)
    match /services/{serviceId} {
      allow read: if isAuthenticated();
      allow write: if hasRole('admin');
    }

    // Reservas
    match /bookings/{bookingId} {
      allow read: if isAuthenticated() &&
                     (resource.data.client_uid == request.auth.uid ||
                      resource.data.caregiver_uid == request.auth.uid ||
                      hasRole('admin'));
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() &&
                       (resource.data.client_uid == request.auth.uid ||
                        resource.data.caregiver_uid == request.auth.uid ||
                        hasRole('admin'));
      allow delete: if hasRole('admin');
    }

    // Chats
    match /chats/{chatId} {
      allow read: if isAuthenticated() &&
                     resource.data.participants.hasAny([request.auth.uid]);
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() &&
                       resource.data.participants.hasAny([request.auth.uid]);

      match /messages/{messageId} {
        allow read: if isAuthenticated();
        allow create: if isAuthenticated();
        allow update, delete: if false;
      }
    }

    // Reseñas (lectura pública, escritura autenticados)
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if isAuthenticated();
      allow update, delete: if hasRole('admin');
    }
  }
}
```

### Para DESARROLLO ESCOLAR (reglas abiertas hasta 2026):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2026, 12, 31);
    }
  }
}
```

**USAR LAS REGLAS DE DESARROLLO durante el proyecto escolar.**

---

## Reglas Storage — `storage.rules`

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // Fotos de mascotas
    match /pets/{petId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.resource.size < 5 * 1024 * 1024  // max 5MB
        && request.resource.contentType.matches('image/.*');
    }

    // Fotos de perfil
    match /profiles/{uid} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.auth.uid == uid
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## Servicios iniciales — Crear en Firestore Console

```
Colección: services
```

**Documento 1 — ID: `hospedaje`**
```json
{
  "id": "hospedaje",
  "nombre": "Hospedaje en Casa",
  "descripcion": "Cuidado de tu perro en el hogar del cuidador, con atención personalizada las 24 horas",
  "categoria": "hospedaje",
  "precio_base": 240,
  "duracion_min": 1440,
  "activo": true
}
```

**Documento 2 — ID: `guarderia`**
```json
{
  "id": "guarderia",
  "nombre": "Guardería Diurna",
  "descripcion": "Cuidado profesional durante el día mientras trabajas, con actividades y socialización",
  "categoria": "guarderia",
  "precio_base": 180,
  "duracion_min": 480,
  "activo": true
}
```

**Documento 3 — ID: `paseo`**
```json
{
  "id": "paseo",
  "nombre": "Paseo Individual",
  "descripcion": "Paseo de 1 hora con tu mascota en parques seguros del vecindario",
  "categoria": "paseo",
  "precio_base": 120,
  "duracion_min": 60,
  "activo": true
}
```
