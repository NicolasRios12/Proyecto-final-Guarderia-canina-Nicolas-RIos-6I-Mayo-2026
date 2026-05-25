# LOGIC.md — Lógica de Negocio Detallada

## 1. Flujo completo de Creación de Reserva

```
CLIENTE
  │
  ├── HomeScreen → toca "Hospedaje" / "Guardería" / "Paseos"
  │
  ├── ServiceListScreen (filtrada por categoria)
  │   └── Lista de cuidadores desde Firestore (rol == 'cuidador')
  │
  ├── CaregiverProfileScreen
  │   ├── Ver info del cuidador
  │   ├── Botón "Reservar ahora" → BookingFormScreen(caregiverUid, serviceId)
  │   └── Botón "Contactar" → crear/abrir ChatRoom
  │
  └── BookingFormScreen
      ├── VALIDAR: servicio seleccionado
      ├── VALIDAR: fecha > hoy
      ├── VALIDAR: hora seleccionada
      ├── VALIDAR: mascota seleccionada
      │
      ├── Al confirmar:
      │   1. Calcular precio_final (precio_base del servicio)
      │   2. Crear doc en bookings/
      │      { estado: 'pendiente',
      │        client_uid: currentUser.uid,
      │        caregiver_uid: caregiverUid,
      │        pet_id: selectedPet.id,
      │        service_id: selectedService.id,
      │        fecha_inicio: fechaSeleccionada,
      │        precio_final: precio_base,
      │        notas: notasCtrl.text,
      │        created_at: Timestamp.now() }
      │   3. SnackBar: "¡Reserva enviada exitosamente!"
      │   4. Navegar a BookingConfirmScreen
      │
      └── BookingConfirmScreen
          ├── Mostrar resumen de reserva
          ├── Botón "Ir al inicio" → context.go('/home')
          └── Botón "Ver chats" → context.go('/home/chats')
```

### BookingRepository — métodos requeridos:

```dart
class BookingRepository {
  final _db = FirebaseFirestore.instance;

  // Crear reserva
  Future<BookingModel> createBooking(BookingModel booking) async {
    final docRef = _db.collection('bookings').doc(booking.id);
    await docRef.set(booking.toMap());
    return booking;
  }

  // Stream de reservas del cliente
  Stream<List<BookingModel>> getClientBookings(String clientUid) {
    return _db
      .collection('bookings')
      .where('client_uid', isEqualTo: clientUid)
      .orderBy('created_at', descending: true)
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => BookingModel.fromMap(d.data(), d.id))
        .toList());
  }

  // Stream de solicitudes pendientes para cuidador
  Stream<List<BookingModel>> getPendingForCaregiver(String caregiverUid) {
    return _db
      .collection('bookings')
      .where('caregiver_uid', isEqualTo: caregiverUid)
      .where('estado', isEqualTo: 'pendiente')
      .orderBy('created_at', descending: true)
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => BookingModel.fromMap(d.data(), d.id))
        .toList());
  }

  // Actualizar estado
  Future<void> updateStatus(String bookingId, BookingStatus status) {
    return _db.collection('bookings').doc(bookingId).update({
      'estado': status.toValue,
    });
  }

  // Stream de reservas activas del cuidador hoy
  Stream<List<BookingModel>> getActiveForCaregiver(String caregiverUid) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _db
      .collection('bookings')
      .where('caregiver_uid', isEqualTo: caregiverUid)
      .where('estado', whereIn: ['confirmada', 'en_curso'])
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => BookingModel.fromMap(d.data(), d.id))
        .where((b) =>
          b.fechaInicio.isAfter(startOfDay) &&
          b.fechaInicio.isBefore(endOfDay))
        .toList());
  }
}
```

---

## 2. Lógica de Aceptación/Rechazo (Cuidador)

```dart
// En RequestsScreen o CaregiverHomeScreen:

Future<void> _aceptarReserva(BookingModel booking) async {
  try {
    // 1. Actualizar estado de la reserva
    await BookingRepository().updateStatus(
      booking.id, BookingStatus.confirmada);

    // 2. Actualizar estado de la mascota
    await PetRepository().updateStatus(booking.petId, 'en_servicio');

    // 3. Crear chat automáticamente si no existe
    await ChatRepository().getOrCreateChat(
      uid1: booking.caregiverUid,
      uid2: booking.clientUid,
    );

    // 4. Feedback al usuario
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Reserva aceptada'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al aceptar: $e'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }
}

Future<void> _rechazarReserva(BookingModel booking) async {
  // Confirmar antes de rechazar
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rechazar solicitud'),
      content: const Text('¿Estás seguro de rechazar esta solicitud?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar')),
        TextButton(onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Rechazar')),
      ],
    ),
  );

  if (confirm != true) return;

  await BookingRepository().updateStatus(booking.id, BookingStatus.cancelada);
  await PetRepository().updateStatus(booking.petId, 'disponible');

  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud rechazada')));
  }
}
```

---

## 3. Chat en Tiempo Real — ChatRepository

```dart
class ChatRepository {
  final _db = FirebaseFirestore.instance;

  // Obtener o crear chat entre 2 usuarios
  Future<String> getOrCreateChat({
    required String uid1,
    required String uid2,
  }) async {
    // Buscar chat existente
    final query = await _db
      .collection('chats')
      .where('participants', arrayContains: uid1)
      .get();

    for (final doc in query.docs) {
      final participants = List<String>.from(doc.data()['participants']);
      if (participants.contains(uid2)) {
        return doc.id; // Chat ya existe
      }
    }

    // Crear nuevo chat
    final chatId = const Uuid().v4();
    await _db.collection('chats').doc(chatId).set({
      'id': chatId,
      'participants': [uid1, uid2],
      'last_message': '',
      'updated_at': Timestamp.now(),
    });

    return chatId;
  }

  // Stream de chats del usuario
  Stream<List<ChatModel>> getChatsForUser(String uid) {
    return _db
      .collection('chats')
      .where('participants', arrayContains: uid)
      .orderBy('updated_at', descending: true)
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => ChatModel.fromMap(d.data(), d.id))
        .toList());
  }

  // Stream de mensajes de un chat
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _db
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => MessageModel.fromMap(d.data(), d.id))
        .toList());
  }

  // Enviar mensaje
  Future<void> sendMessage({
    required String chatId,
    required String senderUid,
    required String text,
  }) async {
    final msgId = const Uuid().v4();
    final now = Timestamp.now();

    // Transacción: crear mensaje + actualizar chat
    final batch = _db.batch();

    batch.set(
      _db.collection('chats').doc(chatId).collection('messages').doc(msgId),
      {
        'id': msgId,
        'chat_id': chatId,
        'sender_uid': senderUid,
        'text': text,
        'timestamp': now,
        'leido': false,
      },
    );

    batch.update(
      _db.collection('chats').doc(chatId),
      {
        'last_message': text.length > 50 ? '${text.substring(0, 50)}...' : text,
        'updated_at': now,
      },
    );

    await batch.commit();
  }
}
```

---

## 4. Gestión de Mascotas — PetRepository

```dart
class PetRepository {
  final _db = FirebaseFirestore.instance;

  // Agregar mascota
  Future<void> addPet(PetModel pet) async {
    await _db.collection('pets').doc(pet.id).set(pet.toMap());
  }

  // Stream de mascotas del usuario
  Stream<List<PetModel>> getUserPets(String ownerUid) {
    return _db
      .collection('pets')
      .where('owner_uid', isEqualTo: ownerUid)
      .orderBy('created_at', descending: true)
      .snapshots()
      .map((snap) => snap.docs
        .map((d) => PetModel.fromMap(d.data(), d.id))
        .toList());
  }

  // Actualizar estado de mascota
  Future<void> updateStatus(String petId, String estado) {
    return _db.collection('pets').doc(petId).update({'estado': estado});
  }

  // Actualizar mascota completa
  Future<void> updatePet(PetModel pet) {
    return _db.collection('pets').doc(pet.id).update(pet.toMap());
  }

  // Eliminar mascota (solo si no tiene reservas activas)
  Future<bool> deletePet(String petId) async {
    // Verificar reservas activas
    final activeBookings = await _db
      .collection('bookings')
      .where('pet_id', isEqualTo: petId)
      .where('estado', whereIn: ['pendiente', 'confirmada', 'en_curso'])
      .get();

    if (activeBookings.docs.isNotEmpty) return false;

    await _db.collection('pets').doc(petId).delete();
    return true;
  }
}
```

---

## 5. ImageService — Subida de imágenes

```dart
class ImageService {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  // Seleccionar imagen de galería o cámara
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final xFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,  // Comprimir al 70%
      maxWidth: 800,
    );
    if (xFile == null) return null;
    return File(xFile.path);
  }

  // Subir foto de mascota
  Future<String> uploadPetImage({
    required File file,
    required String petId,
  }) async {
    final ref = _storage.ref().child('pets/$petId.jpg');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await task.ref.getDownloadURL();
  }

  // Subir foto de perfil de usuario
  Future<String> uploadProfileImage({
    required File file,
    required String uid,
  }) async {
    final ref = _storage.ref().child('profiles/$uid.jpg');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await task.ref.getDownloadURL();
  }
}
```

---

## 6. PetProvider — Estado global de mascotas

```dart
class PetProvider extends ChangeNotifier {
  List<PetModel> _pets = [];
  bool _isLoading = false;
  StreamSubscription? _sub;

  List<PetModel> get pets => _pets;
  bool get isLoading => _isLoading;
  List<PetModel> get availablePets =>
    _pets.where((p) => p.estado == 'disponible').toList();

  void startListening(String ownerUid) {
    _isLoading = true;
    notifyListeners();

    _sub = PetRepository().getUserPets(ownerUid).listen((pets) {
      _pets = pets;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addPet(PetModel pet) async {
    await PetRepository().addPet(pet);
    // El StreamSubscription actualiza la lista automáticamente
  }

  Future<void> deletePet(String petId) async {
    final deleted = await PetRepository().deletePet(petId);
    if (!deleted) {
      throw Exception('No se puede eliminar: la mascota tiene reservas activas');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
```

---

## 7. BookingProvider — Estado global de reservas

```dart
class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  StreamSubscription? _sub;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  int get pendingCount =>
    _bookings.where((b) => b.estado == BookingStatus.pendiente).length;

  List<BookingModel> get activeToday {
    final today = DateTime.now();
    return _bookings.where((b) =>
      b.estado == BookingStatus.confirmada ||
      b.estado == BookingStatus.enCurso).toList();
  }

  double get monthEarnings {
    final now = DateTime.now();
    return _bookings
      .where((b) =>
        b.estado == BookingStatus.completada &&
        b.fechaInicio.month == now.month &&
        b.fechaInicio.year == now.year)
      .fold(0.0, (sum, b) => sum + b.precioFinal);
  }

  void startListeningClient(String clientUid) {
    _sub?.cancel();
    _sub = BookingRepository().getClientBookings(clientUid).listen((bookings) {
      _bookings = bookings;
      notifyListeners();
    });
  }

  void startListeningCaregiver(String caregiverUid) {
    _sub?.cancel();
    _sub = BookingRepository().getPendingForCaregiver(caregiverUid).listen(
      (bookings) {
        _bookings = bookings;
        notifyListeners();
      },
    );
  }

  Future<BookingModel> createBooking({
    required String clientUid,
    required String caregiverUid,
    required String petId,
    required String serviceId,
    required DateTime fechaInicio,
    required double precioFinal,
    String notas = '',
  }) async {
    final booking = BookingModel(
      id: const Uuid().v4(),
      clientUid: clientUid,
      caregiverUid: caregiverUid,
      petId: petId,
      serviceId: serviceId,
      fechaInicio: fechaInicio,
      estado: BookingStatus.pendiente,
      precioFinal: precioFinal,
      notas: notas,
      createdAt: DateTime.now(),
    );

    await BookingRepository().createBooking(booking);
    return booking;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
```

---

## 8. CRUD Admin — Patrón genérico

Todos los CRUD de admin siguen este patrón:

```dart
// State para un CRUD screen genérico:
class _CrudState<T> {
  List<T> allItems = [];
  List<T> filteredItems = [];
  String searchQuery = '';
  bool isLoading = true;

  void filter(String query) {
    searchQuery = query;
    // implementar filtrado específico por tipo
  }
}
```

**UsersCrudScreen** — streams de `users` collection, filtrar por nombre/email/rol.
**PetsCrudScreen** — streams de `pets` collection, filtrar por nombre/raza/dueño.
**BookingsCrudScreen** — streams de `bookings`, filtrar por estado/mascota/fecha.
**ServicesCrudScreen** — streams de `services`, CRUD completo, toggle de activo.

**Campos editables por tabla:**

| Tabla    | Campos editables                                      | No editables  |
|----------|-------------------------------------------------------|---------------|
| Users    | nombre, apellido, telefono, direccion, rol, activo    | uid, email    |
| Pets     | nombre, raza, tamanio, edad_texto, notas_medicas      | owner_uid     |
| Bookings | estado, notas, precio_final                           | client_uid    |
| Services | nombre, descripcion, precio_base, duracion_min, activo | id           |

---

## 9. Utils — Implementaciones requeridas

### validators.dart
```dart
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'El correo es requerido';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
      return 'Ingresa un correo válido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es requerida';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) return 'Las contraseñas no coinciden';
    return null;
  }

  static String? required(String? value, [String fieldName = 'Campo']) {
    if (value == null || value.trim().isEmpty) return '$fieldName es requerido';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null; // opcional
    if (value.length < 10) return 'Teléfono inválido';
    return null;
  }

  static String? weight(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) return 'Ingresa un número válido';
    return null;
  }
}
```

### date_helper.dart
```dart
class DateHelper {
  static String formatDate(DateTime dt) =>
    DateFormat('dd/MM/yyyy').format(dt);

  static String formatDateTime(DateTime dt) =>
    DateFormat('dd/MM/yyyy HH:mm').format(dt);

  static String formatTime(DateTime dt) =>
    DateFormat('HH:mm').format(dt);

  static String formatYear(DateTime dt) =>
    DateFormat('yyyy').format(dt);

  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return DateFormat('HH:mm').format(dt);
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'hace ${diff.inDays} días';
    return DateFormat('dd/MM').format(dt);
  }
}
```

### formatters.dart
```dart
class Formatters {
  static String currency(double amount) =>
    '\$${amount.toStringAsFixed(0)}';

  static String petSize(String tamanio) {
    const map = {
      'pequeño': 'Pequeño', 'mediano': 'Mediano', 'grande': 'Grande'};
    return map[tamanio] ?? tamanio;
  }
}
```
