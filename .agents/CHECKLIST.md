# CHECKLIST.md — Lista de Verificación Final

## Antes de entregar el proyecto, verificar CADA punto:

---

## ✅ AUTENTICACIÓN Y ROLES

- [ ] SplashScreen espera mínimo 2 segundos y verifica `authStateChanges`
- [ ] Login funciona con email/password de Firebase Auth
- [ ] Registro crea usuario en Auth + documento en Firestore
- [ ] Rol `admin` se asigna automáticamente a `admin@dogclub.com`
- [ ] Rol `cuidador` se asigna manualmente desde admin o por email predefinido
- [ ] Rol `cliente` es el default al registrarse
- [ ] Router redirige correctamente según rol al iniciar sesión
- [ ] Router protege rutas: sin sesión → `/login`
- [ ] Logout limpia sesión y redirige a `/login`
- [ ] Mensajes de error en español para todos los códigos de Firebase Auth

---

## ✅ MÓDULO CLIENTE

- [ ] HomeScreen muestra 3 cards de servicio (Hospedaje, Guardería, Paseos)
- [ ] CustomDrawer funciona con hamburger menu
- [ ] ServiceListScreen carga cuidadores de Firestore (rol == 'cuidador')
- [ ] CaregiverProfileScreen muestra info del cuidador y botones de acción
- [ ] BookingFormScreen valida todos los campos antes de habilitar "Confirmar"
- [ ] Selector de fecha no permite fechas pasadas
- [ ] Grid de horarios funciona con selección única
- [ ] Dropdown de mascotas carga las mascotas del usuario
- [ ] Al confirmar reserva se crea documento en colección `bookings`
- [ ] BookingConfirmScreen muestra resumen y acciones post-reserva
- [ ] ProfileScreen muestra foto, nombre, año de registro y lista de mascotas
- [ ] AddPetScreen permite seleccionar foto con image_picker
- [ ] Foto de mascota se sube a Firebase Storage
- [ ] ChatListScreen lista conversaciones con último mensaje y hora
- [ ] ChatRoomScreen muestra mensajes en tiempo real con StreamBuilder
- [ ] Mensajes enviados en burbuja azul derecha, recibidos en gris izquierda
- [ ] Scroll automático al último mensaje al recibir uno nuevo

---

## ✅ MÓDULO CUIDADOR

- [ ] CaregiverHomeScreen muestra 3 stats: pendientes, activas hoy, ganancias mes
- [ ] Lista de solicitudes pendientes con StreamBuilder
- [ ] Botón ✓ Aceptar cambia estado a 'confirmada' y mascota a 'en_servicio'
- [ ] Botón ✗ Rechazar muestra diálogo de confirmación antes de cancelar
- [ ] Al aceptar se crea/abre chat con el cliente automáticamente
- [ ] ActivePetsScreen lista mascotas en servicio del cuidador hoy
- [ ] CaregiverProfileScreen (rol cuidador) permite editar su bio y foto

---

## ✅ MÓDULO ADMIN

- [ ] AdminDashboardScreen muestra grid de tablas con íconos
- [ ] UsersCrudScreen lista todos los usuarios con DataTable
- [ ] UsersCrudScreen permite editar rol, nombre, teléfono
- [ ] UsersCrudScreen permite eliminar usuario (con confirmación)
- [ ] SearchBar filtra usuarios en tiempo real
- [ ] PetsCrudScreen lista todas las mascotas
- [ ] PetsCrudScreen permite editar datos de mascota
- [ ] BookingsCrudScreen lista todas las reservas con estado coloreado
- [ ] BookingsCrudScreen permite cambiar estado de reserva
- [ ] ServicesCrudScreen lista servicios y permite toggle de activo/inactivo
- [ ] ServicesCrudScreen permite editar precio y descripción
- [ ] FAB en todos los CRUD abre formulario de creación

---

## ✅ DATOS Y FIRESTORE

- [ ] Colección `services` tiene 3 documentos (hospedaje, guarderia, paseo)
- [ ] Usuarios de prueba creados en Auth y Firestore (admin, 2 cuidadores, 1 cliente)
- [ ] Al menos 1 mascota de prueba en Firestore
- [ ] Reglas de Firestore en modo prueba (hasta 31/12/2026)
- [ ] Storage configurado en modo prueba

---

## ✅ UI Y DISEÑO

- [ ] Color primario #1E40AF (azul profundo) usado consistentemente
- [ ] Fondo general #F8FAFC en todas las pantallas
- [ ] Cards con `BorderRadius.circular(16)` y sombra sutil
- [ ] Botones primarios azules con `BorderRadius.circular(12)`
- [ ] StatusBadge con colores correctos por estado
- [ ] EmptyState mostrado cuando listas están vacías
- [ ] LoadingShimmer mostrado mientras cargan los datos
- [ ] Material 3 habilitado (`useMaterial3: true`)
- [ ] Google Fonts (Inter) aplicado al theme

---

## ✅ CALIDAD DE CÓDIGO

- [ ] `flutter pub get` → sin errores
- [ ] `flutter analyze` → 0 errores críticos
- [ ] Sin imports sin usar
- [ ] Sin variables declaradas pero no usadas
- [ ] Todos los `async` tienen `await` o son `void`
- [ ] Todos los `StreamBuilder` tienen casos `loading` y `error`
- [ ] Todos los formularios tienen `GlobalKey<FormState>`
- [ ] Todos los `TextEditingController` se hacen `dispose()` en `dispose()`
- [ ] Todos los `StreamSubscription` se cancelan en `dispose()`

---

## ✅ MANEJO DE ERRORES

- [ ] Try/catch en TODAS las operaciones Firebase
- [ ] SnackBar de error en rojo cuando falla una operación
- [ ] SnackBar de éxito en verde cuando se completa una operación
- [ ] Mensajes en español descriptivos y útiles
- [ ] No hay `print()` en producción (usar `debugPrint`)

---

## ✅ ENTREGA FINAL

- [ ] README.md completo con instrucciones de instalación
- [ ] Credenciales de prueba documentadas en README
- [ ] Video demo de 3-5 minutos mostrando los 3 roles
- [ ] Código en repositorio Git con commits descriptivos
- [ ] `.gitignore` incluye `firebase_options.dart` si tiene claves reales
- [ ] App compila y corre en Android o iOS sin errores

---

## README.md Template Final

```markdown
# 🐾 Dog Club — Guardería Canina

Aplicación Flutter para conectar dueños de mascotas con cuidadores
profesionales en Ciudad Juárez, Chihuahua.

## Tecnologías
- Flutter 3.24+ / Dart 3.4+
- Firebase (Auth, Firestore, Storage)
- Provider (estado global)
- Go Router (navegación)
- Material 3

## Características
- 3 roles: Cliente, Cuidador, Administrador
- Sistema de reservas con estados en tiempo real
- Chat en tiempo real entre clientes y cuidadores
- Gestión de mascotas con fotos (Firebase Storage)
- Panel administrativo completo (CRUD de todas las tablas)

## Instalación

### Prerrequisitos
- Flutter SDK 3.24+
- Cuenta Firebase con proyecto configurado
- Android Studio o VS Code

### Pasos
1. Clonar el repositorio:
   \`\`\`bash
   git clone https://github.com/tu-usuario/dog_club.git
   cd dog_club
   \`\`\`

2. Instalar dependencias:
   \`\`\`bash
   flutter pub get
   \`\`\`

3. Configurar Firebase:
   \`\`\`bash
   flutterfire configure
   \`\`\`

4. Correr la app:
   \`\`\`bash
   flutter run
   \`\`\`

## Credenciales de Prueba

| Rol      | Email                      | Password    |
|----------|----------------------------|-------------|
| Admin    | admin@dogclub.com          | admin123    |
| Cuidador | paola.martinez@dogclub.com | password123 |
| Cuidador | diana.juarez@dogclub.com   | password123 |
| Cliente  | cliente1@dogclub.com       | password123 |

## Estructura del proyecto
\`\`\`
lib/
├── config/          # Theme, Routes, Firebase
├── core/            # Models, Enums, Utils, Constants
├── data/            # Repositories, Services
└── presentation/    # Providers, Screens, Widgets
\`\`\`

## Autor
[Tu nombre] — Proyecto Escolar 2024
```

---

## Notas finales para la IA generadora

1. **NO usar** `flutter_image_compress` (no está en pubspec) — usar `imageQuality` en `image_picker` directamente.
2. **NO usar** `firebase_messaging` — notificaciones están fuera de alcance.
3. **Sí usar** `uuid: ^4.4.0` para generar IDs únicos.
4. **Sí usar** `intl` para formateo de fechas con `DateFormat`.
5. **Sí usar** `google_fonts` — importar `Inter` en el theme.
6. Todos los `context.push()`, `context.go()`, `context.pop()` requieren import de `go_router/go_router.dart`.
7. El método `context.read<Provider>()` requiere import de `provider/provider.dart`.
8. Los `StreamBuilder` deben tener SIEMPRE los 3 casos: `waiting`, `error`, y `data`.
9. Los `FutureBuilder` deben tener SIEMPRE los 3 casos: `waiting`, `error`, y `done`.
10. Las constantes de colores van en `AppColors` — NUNCA hardcodear `Color(0xFF...)` fuera de ese archivo.
