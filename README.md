# 🐾 Dog Club — Guardería Canina

Aplicación móvil para gestión de guardería canina desarrollada con Flutter y Firebase.

## Descripción

Dog Club es una plataforma que conecta dueños de mascotas con cuidadores profesionales. Ofrece tres tipos de servicios: **Hospedaje**, **Guardería Diurna** y **Paseos Individuales**.

## Características

### 👤 Clientes
- Registro e inicio de sesión con email/contraseña
- Explorar cuidadores por categoría de servicio
- Ver perfil y reseñas de cuidadores
- Reservar servicios con selección de fecha, hora y mascota
- Agregar y gestionar mascotas
- Chat en tiempo real con cuidadores
- Editar perfil y foto

### 🐕 Cuidadores
- Dashboard con estadísticas (pendientes, activas, ganancias)
- Aceptar/rechazar solicitudes de reserva
- Ver mascotas activas en servicio
- Chat con clientes
- Editar perfil y biografía

### 🔧 Administrador
- Panel CRUD de usuarios (cambiar roles, eliminar)
- Panel CRUD de mascotas
- Panel CRUD de reservas (cambiar estados)
- Panel CRUD de servicios (precios, activar/desactivar)

## Tecnologías

| Tecnología | Uso |
|---|---|
| Flutter 3.24+ | Framework UI |
| Dart 3.4+ | Lenguaje |
| Firebase Auth | Autenticación |
| Cloud Firestore | Base de datos |
| Firebase Storage | Almacenamiento de imágenes |
| Provider | Gestión de estado |
| GoRouter | Navegación |

## Estructura del Proyecto

```
lib/
├── main.dart
├── config/
│   ├── firebase_options.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── enums/
│   ├── models/
│   └── utils/
├── data/
│   ├── repositories/
│   └── services/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

## Configuración

### 1. Crear proyecto Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Crea un nuevo proyecto
3. Habilita **Authentication** (Email/Password)
4. Habilita **Cloud Firestore**
5. Habilita **Firebase Storage**

### 2. Configurar FlutterFire
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Ejecutar
```bash
flutter run
```

## Roles y Accesos

| Rol | Acceso |
|---|---|
| **cliente** | Explorar servicios, reservar, chat, perfil, mascotas |
| **cuidador** | Dashboard, solicitudes, mascotas activas, chat, perfil |
| **admin** | CRUD completo de usuarios, mascotas, reservas y servicios |

### Cuenta Admin
El email `admin@dogclub.com` se registra automáticamente con rol `admin`.

## Datos Semilla
La app siembra automáticamente 3 servicios base en el primer inicio si la colección `services` está vacía:
- Hospedaje en Casa ($240/noche)
- Guardería Diurna ($180/día)
- Paseo Individual ($120/hora)

## Licencia
Proyecto escolar — Uso educativo.
