# SCREENS.md — Especificaciones UI por Pantalla

## Rutas Go Router completas

```dart
// Auth
GoRoute(path: '/splash',   builder: (_,__) => const SplashScreen()),
GoRoute(path: '/login',    builder: (_,__) => const LoginScreen()),
GoRoute(path: '/register', builder: (_,__) => const RegisterScreen()),

// Cliente
GoRoute(path: '/home', builder: (_,__) => const HomeScreen(),
  routes: [
    GoRoute(path: 'services/:categoria', builder: (_, s) =>
      ServiceListScreen(categoria: s.pathParameters['categoria']!)),
    GoRoute(path: 'caregiver/:uid', builder: (_, s) =>
      CaregiverProfileScreen(caregiverUid: s.pathParameters['uid']!)),
    GoRoute(path: 'booking', builder: (_, s) =>
      BookingFormScreen(extra: s.extra as Map<String,dynamic>?)),
    GoRoute(path: 'booking-confirm', builder: (_, s) =>
      BookingConfirmScreen(booking: s.extra as BookingModel)),
    GoRoute(path: 'profile', builder: (_,__) => const ProfileScreen()),
    GoRoute(path: 'edit-profile', builder: (_,__) => const EditProfileScreen()),
    GoRoute(path: 'pets', builder: (_,__) => const PetsListScreen()),
    GoRoute(path: 'add-pet', builder: (_,__) => const AddPetScreen()),
    GoRoute(path: 'chats', builder: (_,__) => const ChatListScreen()),
    GoRoute(path: 'chat/:chatId', builder: (_, s) =>
      ChatRoomScreen(chatId: s.pathParameters['chatId']!,
                     otherUid: s.uri.queryParameters['otherUid']!)),
  ],
),

// Cuidador
GoRoute(path: '/caregiver', builder: (_,__) => const CaregiverHomeScreen(),
  routes: [
    GoRoute(path: 'requests', builder: (_,__) => const RequestsScreen()),
    GoRoute(path: 'active-pets', builder: (_,__) => const ActivePetsScreen()),
    GoRoute(path: 'profile', builder: (_,__) => const CaregiverProfileScreen()),
    GoRoute(path: 'chat/:chatId', builder: (_, s) =>
      ChatRoomScreen(chatId: s.pathParameters['chatId']!,
                     otherUid: s.uri.queryParameters['otherUid']!)),
  ],
),

// Admin
GoRoute(path: '/admin', builder: (_,__) => const AdminDashboardScreen(),
  routes: [
    GoRoute(path: 'users',    builder: (_,__) => const UsersCrudScreen()),
    GoRoute(path: 'pets',     builder: (_,__) => const PetsCrudScreen()),
    GoRoute(path: 'bookings', builder: (_,__) => const BookingsCrudScreen()),
    GoRoute(path: 'services', builder: (_,__) => const ServicesCrudScreen()),
  ],
),
```

---

## PANTALLA 1: LoginScreen

**Ruta:** `/login`

**Layout:**
```
Scaffold(backgroundColor: #F8FAFC)
└── SingleChildScrollView
    └── Padding(horizontal: 24)
        └── Column(mainAxisAlignment: center)
            ├── SizedBox(height: 80)
            ├── Icon(pets, size: 64, color: #1E40AF)
            ├── Text("Dog Club", fontSize: 28, bold, color: #1E40AF)
            ├── Text("Guardería Canina", fontSize: 14, color: #475569)
            ├── SizedBox(height: 48)
            ├── TextFormField(email, prefixIcon: email_icon)
            ├── SizedBox(height: 16)
            ├── TextFormField(password, obscureText, suffixIcon: ojo)
            ├── SizedBox(height: 8)
            ├── Align(right) → TextButton("¿Olvidaste tu contraseña?")
            ├── SizedBox(height: 24)
            ├── PrimaryButton("Iniciar sesión", onPressed: _login)
            ├── SizedBox(height: 16)
            └── Row → Text("¿No tienes cuenta?") + TextButton("Regístrate")
```

**Validaciones:**
- Email: no vacío, formato válido
- Password: mínimo 6 caracteres
- Mostrar error en rojo debajo del campo
- Botón deshabilitado (con spinner) durante login

---

## PANTALLA 2: RegisterScreen

**Ruta:** `/register`

**AppBar:** `"Registrarse"` con botón back

**Campos del formulario (en orden):**
1. Nombre — `TextFormField`, `textCapitalization: words`
2. Apellido — `TextFormField`, `textCapitalization: words`
3. Correo electrónico — `TextFormField`, `keyboardType: email`
4. Teléfono — `TextFormField`, `keyboardType: phone`, hint: `"+52 656 123 4567"`
5. Contraseña — `TextFormField`, `obscureText`, con ícono ojo
6. Confirmar contraseña — `TextFormField`, `obscureText`

**Botón:** `PrimaryButton("Registrarse")` — full width

**Al éxito:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('¡Registro exitoso! Inicia sesión.'),
    backgroundColor: Color(0xFF10B981),
  ),
);
context.go('/login');
```

---

## PANTALLA 3: HomeScreen (Cliente)

**Ruta:** `/home`
**AppBar:** Logo + hamburger → abre `CustomDrawer`

**Cuerpo — ScrollView:**
```
Column
├── Container(color: #1E40AF, padding: 24)
│   ├── Text("Cuidadores de mascotas de confianza cerca de ti",
│   │         style: white, bold, fontSize: 22)
│   └── Text("Reserva espacios sin filas y paseos seguros para perros",
│             style: white70, fontSize: 14)
│
├── SizedBox(height: 24)
├── Padding(horizontal: 16)
│   └── Text("Nuestros Servicios", fontSize: 18, bold)
├── SizedBox(height: 12)
└── Padding(horizontal: 16)
    └── Column de 3 ServiceTypeCard:
        ├── _ServiceTypeCard(
        │     icon: Icons.hotel,
        │     titulo: "Hospedaje",
        │     subtitulo: "Ver opciones disponibles",
        │     onTap: () => context.push('/home/services/hospedaje'))
        ├── _ServiceTypeCard(
        │     icon: Icons.groups,
        │     titulo: "Guardería",
        │     subtitulo: "Ver opciones disponibles",
        │     onTap: () => context.push('/home/services/guarderia'))
        └── _ServiceTypeCard(
              icon: Icons.directions_walk,
              titulo: "Paseos",
              subtitulo: "Ver opciones disponibles",
              onTap: () => context.push('/home/services/paseo'))
```

**`_ServiceTypeCard`:**
```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Color(0xFF1E40AF)),
    ),
    title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitulo, style: TextStyle(color: Color(0xFF475569))),
    trailing: Icon(Icons.chevron_right, color: Color(0xFF1E40AF)),
    onTap: onTap,
  ),
)
```

---

## PANTALLA 4: ServiceListScreen

**Ruta:** `/home/services/:categoria`
**Parámetro:** `categoria` (hospedaje | guarderia | paseo)

**AppBar:**
```dart
AppBar(
  title: Text('${serviceType.emoji} ${serviceType.label}'),
  backgroundColor: Color(0xFF1E40AF),
  foregroundColor: Colors.white,
)
```

**Cuerpo:**
```
Column
├── Padding(16) → Text("Cuidadores Populares", fontSize: 16, bold)
└── Expanded
    └── StreamBuilder<List<UserModel>>(
          stream: UserRepository().getCaregivers(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return LoadingShimmer();
            if (!snap.hasData || snap.data!.isEmpty)
              return EmptyState(message: 'No hay cuidadores disponibles');
            return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (_, i) => ServiceCard(
                caregiver: snap.data![i],
                onReservar: () => context.push('/home/caregiver/${snap.data![i].uid}'),
              ),
            );
          },
        )
```

---

## PANTALLA 5: CaregiverProfileScreen (vista cliente)

**Ruta:** `/home/caregiver/:uid`

**Secciones:**
1. **Hero image** — `CachedNetworkImage` o avatar con iniciales, height: 220
2. **Sección "¿Quién cuida?":**
   - Avatar circular 80px
   - `caregiver.nombreCompleto`
   - `"Miembro desde ${DateHelper.formatYear(caregiver.fechaRegistro)}"`
   - `RatingStars(rating: 4.8, reviewCount: 23)`
3. **Sección "SERVICIOS Y TARIFAS":**
   - Tile por cada servicio con icono, nombre, precio "Desde \$XXX"
   - Lista de 3 puntos de lo que ofrece
4. **Botones:**
   - `PrimaryButton("Reservar ahora")` → context.push('/home/booking', extra: {...})
   - `OutlinedButton("Contactar")` → crear/abrir chat

---

## PANTALLA 6: BookingFormScreen

**Ruta:** `/home/booking`
**Extra:** `Map<String,dynamic>` con `caregiverUid`, `serviceId` (opcionales)

**Campos:**
1. **Servicio** — `DropdownButtonFormField<ServiceModel>` (cargado de Firestore)
2. **Fecha** — `TextFormField` read-only + `showDatePicker` (solo fechas > hoy)
   ```dart
   final picked = await showDatePicker(
     context: context,
     initialDate: DateTime.now().add(Duration(days: 1)),
     firstDate: DateTime.now().add(Duration(days: 1)),
     lastDate: DateTime.now().add(Duration(days: 90)),
   );
   ```
3. **Hora** — Grid de botones de hora:
   ```dart
   Wrap(
     spacing: 8, runSpacing: 8,
     children: ['09:00', '10:00', '11:00', '12:00',
                 '14:00', '15:00', '16:00', '17:00']
       .map((h) => ChoiceChip(
             label: Text(h),
             selected: _selectedHour == h,
             onSelected: (_) => setState(() => _selectedHour = h),
             selectedColor: Color(0xFF1E40AF),
             labelStyle: TextStyle(
               color: _selectedHour == h ? Colors.white : Colors.black,
             ),
           ))
       .toList(),
   )
   ```
4. **Mascota** — `DropdownButtonFormField<PetModel>` (del PetProvider)

**Sección de reseñas:** 3 `ReviewCard` hardcodeadas o de Firestore

**Botón confirmar:**
```dart
PrimaryButton(
  "Confirmar reserva",
  onPressed: _isFormComplete ? _confirmarReserva : null,
)
```

**Texto helper cuando incompleto:**
```dart
if (!_isFormComplete)
  Text(
    "Selecciona fecha, hora y mascota para continuar",
    style: TextStyle(color: Color(0xFF475569), fontSize: 13),
    textAlign: TextAlign.center,
  )
```

---

## PANTALLA 7: BookingConfirmScreen

**Ruta:** `/home/booking-confirm`
**Extra:** `BookingModel`

**Layout:**
```
Column(mainAxisAlignment: center)
├── Icon(check_circle, size: 80, color: #10B981)
├── Text("¡Reserva confirmada!", fontSize: 24, bold)
├── Text("Tu reserva ha sido enviada al cuidador", color: #475569)
├── SizedBox(height: 32)
├── Card con detalles: mascota, servicio, fecha, precio
├── SizedBox(height: 24)
├── PrimaryButton("Ir al inicio") → context.go('/home')
└── OutlinedButton("Ver mis reservas") → context.go('/home')
```

---

## PANTALLA 8: ProfileScreen (Cliente)

**Ruta:** `/home/profile`

**AppBar:** `"Mi Perfil"`

**Layout:**
```
CustomScrollView
├── SliverToBoxAdapter → Stack con foto de perfil circular
│   ├── CircleAvatar(radius: 60, backgroundImage: fotoUrl)
│   └── Positioned(bottom:0, right:0)
│       └── CircleAvatar(radius:16, color: #1E40AF)
│           └── Icon(edit, size:16, white)
│
├── SliverToBoxAdapter → Column(info personal)
│   ├── Text(nombreCompleto, bold, 20)
│   ├── Text("Miembro desde ${year}", color: #475569)
│   └── OutlinedButton("Editar Perfil") → context.push('/home/edit-profile')
│
├── SliverToBoxAdapter → Divider
│
├── SliverToBoxAdapter → Row("X mascotas" + IconButton(add))
│
└── SliverList → Mascotas del usuario (StreamBuilder)
    └── PetTile(pet) → ListTile con foto, nombre, estado badge, edad
```

---

## PANTALLA 9: AddPetScreen

**Ruta:** `/home/add-pet`
**AppBar:** `"Agregar Mascota"`

**Formulario completo:**
```dart
// Foto — al inicio del formulario
GestureDetector(
  onTap: _pickImage,
  child: CircleAvatar(
    radius: 50,
    backgroundImage: _imageFile != null
      ? FileImage(_imageFile!) : null,
    child: _imageFile == null
      ? Icon(Icons.camera_alt, size: 32) : null,
  ),
)

// Campos
TextFormField(label: "Nombre de tu mascota")
TextFormField(label: "Raza")
TextFormField(label: "Edad", hint: "Ej: 2 años, 6 meses")
DropdownButtonFormField(label: "Sexo", items: ["Macho", "Hembra"])
TextFormField(label: "Peso (kg)", keyboardType: number)
DropdownButtonFormField(label: "Tamaño",
  items: ["Pequeño", "Mediano", "Grande"])
TextFormField(label: "Notas médicas", maxLines: 3, optional: true)
```

**Guardado:**
```dart
Future<void> _guardarMascota() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isLoading = true);

  try {
    String fotoUrl = '';
    if (_imageFile != null) {
      fotoUrl = await ImageService().uploadPetImage(
        file: _imageFile!,
        petId: const Uuid().v4(),
      );
    }

    final pet = PetModel(
      id: const Uuid().v4(),
      ownerUid: auth.currentUser!.uid,
      nombre: _nombreCtrl.text.trim(),
      // ... resto de campos
      fotoUrl: fotoUrl,
      estado: 'disponible',
      createdAt: DateTime.now(),
    );

    await context.read<PetProvider>().addPet(pet);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Mascota agregada exitosamente!')),
      );
      context.pop();
    }
  } catch (e) {
    // mostrar error
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

---

## PANTALLA 10: ChatListScreen

**Ruta:** `/home/chats`
**AppBar:** `"Chats"`

```dart
StreamBuilder<List<ChatModel>>(
  stream: ChatRepository().getChatsForUser(auth.currentUser!.uid),
  builder: (ctx, snap) {
    if (!snap.hasData) return LoadingShimmer();
    if (snap.data!.isEmpty) return EmptyState(message: "Sin conversaciones");

    return ListView.builder(
      itemCount: snap.data!.length,
      itemBuilder: (_, i) {
        final chat = snap.data![i];
        final otherUid = chat.otherParticipant(auth.currentUser!.uid);
        return FutureBuilder<UserModel?>(
          future: UserRepository().getUser(otherUid),
          builder: (_, userSnap) {
            final other = userSnap.data;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: other?.fotoUrl.isNotEmpty == true
                  ? NetworkImage(other!.fotoUrl) : null,
                child: other?.fotoUrl.isEmpty == true
                  ? Text(other!.nombre[0]) : null,
              ),
              title: Text(other?.nombreCompleto ?? 'Cargando...'),
              subtitle: Text(chat.lastMessage,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xFF475569))),
              trailing: Text(DateHelper.formatRelative(chat.updatedAt),
                style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
              onTap: () => context.push(
                '/home/chat/${chat.id}?otherUid=$otherUid'),
            );
          },
        );
      },
    );
  },
)
```

---

## PANTALLA 11: ChatRoomScreen

**Ruta:** `/home/chat/:chatId`
**Query param:** `otherUid`

**Estructura crítica:**
```dart
class ChatRoomScreen extends StatefulWidget {
  final String chatId;
  final String otherUid;
  // ...
}

// Build:
Column(
  children: [
    Expanded(
      child: StreamBuilder<List<MessageModel>>(
        stream: ChatRepository().getMessages(chatId),
        builder: (ctx, snap) {
          final msgs = snap.data ?? [];
          // Auto-scroll al último mensaje
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return ListView.builder(
            controller: _scrollController,
            itemCount: msgs.length,
            itemBuilder: (_, i) => _MessageBubble(
              msg: msgs[i],
              isMe: msgs[i].senderUid == auth.currentUser!.uid,
            ),
          );
        },
      ),
    ),
    _MessageInput(onSend: _sendMessage),
  ],
)
```

**`_MessageBubble`:**
```dart
Align(
  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  child: Container(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
    decoration: BoxDecoration(
      color: isMe ? Color(0xFF1E40AF) : Color(0xFFE2E8F0),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(msg.text,
          style: TextStyle(color: isMe ? Colors.white : Color(0xFF0F172A))),
        SizedBox(height: 4),
        Text(DateHelper.formatTime(msg.timestamp),
          style: TextStyle(
            fontSize: 11,
            color: isMe ? Colors.white70 : Color(0xFF475569))),
      ],
    ),
  ),
)
```

---

## PANTALLA 12: CaregiverHomeScreen

**Ruta:** `/caregiver`

**Cards de resumen (Row de 3):**
```dart
Row(children: [
  _StatCard(label: "Pendientes", value: pendingCount, color: Color(0xFFF59E0B)),
  _StatCard(label: "Activas Hoy", value: activeCount, color: Color(0xFF3B82F6)),
  _StatCard(label: "Ganancias", value: "\$$monthEarnings", color: Color(0xFF10B981)),
])
```

**Sección Solicitudes Pendientes:**
```dart
StreamBuilder<List<BookingModel>>(
  stream: BookingRepository().getPendingForCaregiver(auth.currentUser!.uid),
  builder: (_, snap) => ListView(
    children: snap.data!.map((b) => BookingCard(
      booking: b,
      onAceptar: () => _aceptarReserva(b),
      onRechazar: () => _rechazarReserva(b),
    )).toList(),
  ),
)
```

---

## PANTALLA 13: AdminDashboardScreen

**Ruta:** `/admin`
**AppBar:** `"Panel de Administración"`

**Grid 2 columnas:**
```dart
GridView.count(
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  padding: EdgeInsets.all(16),
  childAspectRatio: 1.1,
  children: [
    _AdminCard(icon: Icons.people, title: "Usuarios",
      onTap: () => context.push('/admin/users')),
    _AdminCard(icon: Icons.pets, title: "Mascotas",
      onTap: () => context.push('/admin/pets')),
    _AdminCard(icon: Icons.miscellaneous_services, title: "Servicios",
      onTap: () => context.push('/admin/services')),
    _AdminCard(icon: Icons.calendar_today, title: "Reservas",
      onTap: () => context.push('/admin/bookings')),
  ],
)
```

---

## PANTALLAS CRUD Admin (patrón común)

**Ejemplo: UsersCrudScreen**
```dart
// AppBar con SearchBar
// FAB para crear
// StreamBuilder<List<UserModel>> con DataTable o ListView

DataTable(
  columns: [
    DataColumn(label: Text('Nombre')),
    DataColumn(label: Text('Rol')),
    DataColumn(label: Text('Email')),
    DataColumn(label: Text('Acciones')),
  ],
  rows: users.map((u) => DataRow(cells: [
    DataCell(Text(u.nombreCompleto)),
    DataCell(StatusBadge(label: u.rol.name, status: u.rol.name)),
    DataCell(Text(u.email)),
    DataCell(Row(children: [
      IconButton(icon: Icon(Icons.edit), onPressed: () => _editUser(u)),
      IconButton(icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _confirmDelete(u)),
    ])),
  ])).toList(),
)
```

**Diálogo de confirmación de eliminación:**
```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: Text('Confirmar eliminación'),
    content: Text('¿Estás seguro de eliminar este registro? Esta acción no se puede deshacer.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
      TextButton(
        onPressed: () { Navigator.pop(context); _deleteUser(user); },
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: Text('Eliminar'),
      ),
    ],
  ),
)
```
