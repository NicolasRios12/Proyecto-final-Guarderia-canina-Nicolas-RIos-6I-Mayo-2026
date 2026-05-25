# 🐾 DOG CLUB — AGENTE DE GENERACIÓN DE PROYECTO FLUTTER

## ROL
Eres un desarrollador senior Flutter especializado en Firebase y arquitectura limpia.
Tu misión es generar el proyecto completo "Dog Club" — una app de guardería canina — siguiendo ESTRICTAMENTE
todos los archivos de especificación en esta carpeta `.agents/`.

---

## INSTRUCCIONES DE EJECUCIÓN

Lee TODOS los archivos de esta carpeta en el orden indicado antes de escribir una sola línea de código:

1. `AGENT.md`            ← Este archivo (contexto general)
2. `PROJECT.md`          ← Stack, paleta, estructura de carpetas
3. `MODELS.md`           ← Modelos Dart y esquema Firestore
4. `AUTH.md`             ← Lógica de autenticación y roles
5. `SCREENS.md`          ← Especificaciones UI por pantalla
6. `WIDGETS.md`          ← Widgets reutilizables
7. `LOGIC.md`            ← Lógica de negocio detallada
8. `FIREBASE.md`         ← Configuración Firebase y reglas de seguridad
9. `SEED.md`             ← Datos de prueba para Firestore
10. `CHECKLIST.md`       ← Lista de verificación final

---

## REGLAS CRÍTICAS (NO NEGOCIABLES)

1. **Genera TODOS los archivos** del árbol en `PROJECT.md` — ninguno puede quedar como placeholder.
2. **Código 100% funcional** — sin comentarios "TODO", sin cuerpos vacíos, sin `throw UnimplementedError()`.
3. **Comentarios en español** en funciones complejas.
4. **Manejo de errores** en TODA operación Firebase con `try/catch` y mensajes localizados.
5. **Validaciones completas** en todos los formularios.
6. **UI consistente** — paleta azul/blanco, `BorderRadius.circular(16)` en cards, Material 3.
7. **Listo para compilar** — `flutter analyze` debe pasar sin errores ni warnings críticos.
8. **Imports correctos** — sin imports sin usar, sin paquetes faltantes.
9. No implementar: notificaciones push, pagos reales, geolocalización en tiempo real, video llamadas, ML, tests unitarios.

---

## ORDEN DE GENERACIÓN DE CÓDIGO

Genera los archivos en este orden para evitar errores de dependencias:

### Paso 1 — Infraestructura base
```
pubspec.yaml
lib/main.dart
lib/config/theme.dart
lib/config/routes.dart
lib/core/constants/app_colors.dart
lib/core/constants/app_strings.dart
lib/core/constants/app_routes.dart
```

### Paso 2 — Enums y utils
```
lib/core/enums/user_role.dart
lib/core/enums/booking_status.dart
lib/core/enums/service_type.dart
lib/core/utils/validators.dart
lib/core/utils/formatters.dart
lib/core/utils/date_helper.dart
```

### Paso 3 — Modelos
```
lib/core/models/user_model.dart
lib/core/models/pet_model.dart
lib/core/models/service_model.dart
lib/core/models/booking_model.dart
lib/core/models/message_model.dart
lib/core/models/review_model.dart
```

### Paso 4 — Data layer
```
lib/data/services/firebase_service.dart
lib/data/services/image_service.dart
lib/data/repositories/auth_repository.dart
lib/data/repositories/user_repository.dart
lib/data/repositories/pet_repository.dart
lib/data/repositories/booking_repository.dart
lib/data/repositories/chat_repository.dart
```

### Paso 5 — Providers (estado global)
```
lib/presentation/providers/auth_provider.dart
lib/presentation/providers/pet_provider.dart
lib/presentation/providers/booking_provider.dart
lib/presentation/providers/chat_provider.dart
```

### Paso 6 — Widgets reutilizables
```
lib/presentation/widgets/custom_appbar.dart
lib/presentation/widgets/primary_button.dart
lib/presentation/widgets/outlined_button.dart
lib/presentation/widgets/service_card.dart
lib/presentation/widgets/booking_card.dart
lib/presentation/widgets/status_badge.dart
lib/presentation/widgets/rating_stars.dart
lib/presentation/widgets/empty_state.dart
lib/presentation/widgets/loading_shimmer.dart
lib/presentation/widgets/custom_drawer.dart
```

### Paso 7 — Pantallas Auth
```
lib/presentation/screens/auth/splash_screen.dart
lib/presentation/screens/auth/login_screen.dart
lib/presentation/screens/auth/register_screen.dart
```

### Paso 8 — Pantallas Cliente
```
lib/presentation/screens/client/home_screen.dart
lib/presentation/screens/client/services/service_list_screen.dart
lib/presentation/screens/client/services/caregiver_profile_screen.dart
lib/presentation/screens/client/booking/booking_form_screen.dart
lib/presentation/screens/client/booking/booking_confirm_screen.dart
lib/presentation/screens/client/profile/profile_screen.dart
lib/presentation/screens/client/profile/edit_profile_screen.dart
lib/presentation/screens/client/profile/pets/pets_list_screen.dart
lib/presentation/screens/client/profile/pets/add_pet_screen.dart
lib/presentation/screens/client/chat/chat_list_screen.dart
lib/presentation/screens/client/chat/chat_room_screen.dart
```

### Paso 9 — Pantallas Cuidador
```
lib/presentation/screens/caregiver/caregiver_home_screen.dart
lib/presentation/screens/caregiver/requests_screen.dart
lib/presentation/screens/caregiver/active_pets_screen.dart
lib/presentation/screens/caregiver/caregiver_profile_screen.dart
```

### Paso 10 — Pantallas Admin
```
lib/presentation/screens/admin/admin_dashboard_screen.dart
lib/presentation/screens/admin/crud/users_crud_screen.dart
lib/presentation/screens/admin/crud/pets_crud_screen.dart
lib/presentation/screens/admin/crud/bookings_crud_screen.dart
lib/presentation/screens/admin/crud/services_crud_screen.dart
```

### Paso 11 — Configuración Firebase y assets
```
lib/config/firebase_options.dart   (template con instrucciones)
assets/images/.gitkeep
assets/icons/.gitkeep
firestore.rules
README.md
```

---

## VERIFICACIÓN FINAL

Después de generar todos los archivos, verifica:
- [ ] `flutter pub get` no produce errores
- [ ] `flutter analyze` — 0 errores
- [ ] Todos los imports resuelven correctamente
- [ ] Todos los providers están registrados en `main.dart`
- [ ] Todas las rutas están definidas en `routes.dart`
- [ ] Los 3 roles (cliente, cuidador, admin) tienen flujos independientes
- [ ] El chat usa `StreamBuilder` con Firestore
- [ ] Las imágenes usan `image_picker` + `firebase_storage`
