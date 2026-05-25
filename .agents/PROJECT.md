# PROJECT.md — Especificaciones del Proyecto Dog Club

## Stack Tecnológico
- Flutter 3.24+ (Dart 3.4+)
- Firebase Auth, Firestore, Storage
- Provider ^6.1.2 para estado global
- Go Router ^14.2.0 para navegación
- Material 3 Design

---

## Paleta de Colores

| Token            | Hex       | Uso                          |
|------------------|-----------|------------------------------|
| Primary          | #1E40AF   | Botones, appbar, acentos     |
| Secondary        | #3B82F6   | Botones secundarios, links   |
| Surface          | #FFFFFF   | Fondo de cards               |
| Background       | #F8FAFC   | Fondo general de pantallas   |
| Text Primary     | #0F172A   | Títulos y cuerpo principal   |
| Text Secondary   | #475569   | Subtítulos y metadatos       |
| Success          | #10B981   | Estado completada, aceptado  |
| Warning          | #F59E0B   | Estado pendiente             |
| Error            | #EF4444   | Estado cancelada, errores    |

---

## pubspec.yaml COMPLETO

```yaml
name: dog_club
description: Aplicación de guardería canina - Proyecto Escolar
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.22.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.2.0
  firebase_auth: ^5.1.4
  cloud_firestore: ^5.4.0
  firebase_storage: ^12.1.3

  # Estado y Navegación
  provider: ^6.1.2
  go_router: ^14.2.0

  # Utilidades
  intl: ^0.19.0
  cached_network_image: ^3.3.1
  image_picker: ^1.1.2
  flutter_svg: ^2.0.10
  google_fonts: ^6.2.1
  flutter_rating_bar: ^4.0.1
  shimmer: ^3.0.0
  url_launcher: ^6.3.0
  uuid: ^4.4.0

  # UI
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

---

## Árbol de Archivos COMPLETO

Genera CADA UNO de los siguientes archivos con código completo y funcional:

```
dog_club/
├── pubspec.yaml
├── README.md
├── firestore.rules
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── theme.dart
│   │   ├── routes.dart
│   │   └── firebase_options.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_routes.dart
│   │   ├── enums/
│   │   │   ├── user_role.dart
│   │   │   ├── booking_status.dart
│   │   │   └── service_type.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── date_helper.dart
│   │   └── models/
│   │       ├── user_model.dart
│   │       ├── pet_model.dart
│   │       ├── service_model.dart
│   │       ├── booking_model.dart
│   │       ├── message_model.dart
│   │       └── review_model.dart
│   ├── data/
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── user_repository.dart
│   │   │   ├── pet_repository.dart
│   │   │   ├── booking_repository.dart
│   │   │   └── chat_repository.dart
│   │   └── services/
│   │       ├── firebase_service.dart
│   │       └── image_service.dart
│   └── presentation/
│       ├── providers/
│       │   ├── auth_provider.dart
│       │   ├── pet_provider.dart
│       │   ├── booking_provider.dart
│       │   └── chat_provider.dart
│       ├── screens/
│       │   ├── auth/
│       │   │   ├── splash_screen.dart
│       │   │   ├── login_screen.dart
│       │   │   └── register_screen.dart
│       │   ├── client/
│       │   │   ├── home_screen.dart
│       │   │   ├── services/
│       │   │   │   ├── service_list_screen.dart
│       │   │   │   └── caregiver_profile_screen.dart
│       │   │   ├── booking/
│       │   │   │   ├── booking_form_screen.dart
│       │   │   │   └── booking_confirm_screen.dart
│       │   │   ├── profile/
│       │   │   │   ├── profile_screen.dart
│       │   │   │   ├── edit_profile_screen.dart
│       │   │   │   └── pets/
│       │   │   │       ├── pets_list_screen.dart
│       │   │   │       └── add_pet_screen.dart
│       │   │   └── chat/
│       │   │       ├── chat_list_screen.dart
│       │   │       └── chat_room_screen.dart
│       │   ├── caregiver/
│       │   │   ├── caregiver_home_screen.dart
│       │   │   ├── requests_screen.dart
│       │   │   ├── active_pets_screen.dart
│       │   │   └── caregiver_profile_screen.dart
│       │   └── admin/
│       │       ├── admin_dashboard_screen.dart
│       │       └── crud/
│       │           ├── users_crud_screen.dart
│       │           ├── pets_crud_screen.dart
│       │           ├── bookings_crud_screen.dart
│       │           └── services_crud_screen.dart
│       └── widgets/
│           ├── custom_appbar.dart
│           ├── primary_button.dart
│           ├── outlined_button.dart
│           ├── service_card.dart
│           ├── booking_card.dart
│           ├── status_badge.dart
│           ├── rating_stars.dart
│           ├── empty_state.dart
│           ├── loading_shimmer.dart
│           └── custom_drawer.dart
└── assets/
    ├── images/
    │   └── .gitkeep
    └── icons/
        └── .gitkeep
```
