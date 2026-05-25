# MODELS.md — Modelos de Datos Dart y Esquema Firestore

## Reglas generales para todos los modelos

- Todos los modelos tienen: constructor, `fromMap(Map, id)`, `toMap()`, `copyWith()`
- Los campos `timestamp` de Firestore se mapean a `DateTime` en Dart
- Todos los modelos son inmutables (`final` en todos los campos)
- Los `enum` deben tener métodos `fromString()` y `toValue()`

---

## 1. UserModel — `users/{uid}`

**Colección Firestore:** `users`
**Documento ID:** UID de Firebase Auth

```dart
class UserModel {
  final String uid;
  final String email;
  final String nombre;
  final String apellido;
  final String telefono;
  final String direccion;
  final UserRole rol;       // enum: cliente | cuidador | admin
  final String fotoUrl;
  final String bio;
  final DateTime fechaRegistro;
  final bool activo;
}
```

**Notas de implementación:**
- `rol` se serializa como String ('cliente', 'cuidador', 'admin')
- `fechaRegistro` viene de Firestore como `Timestamp`, convertir con `.toDate()`
- `fotoUrl` puede ser cadena vacía si no tiene foto
- Getter computado: `String get nombreCompleto => '$nombre $apellido'`

---

## 2. PetModel — `pets/{petId}`

**Colección Firestore:** `pets` (colección raíz)
**Documento ID:** UUID generado con paquete `uuid`

```dart
class PetModel {
  final String id;
  final String ownerUid;
  final String nombre;
  final String raza;
  final PetSize tamanio;      // enum: pequeño | mediano | grande
  final String edadTexto;    // "2 años, 6 meses"
  final String sexo;         // 'macho' | 'hembra'
  final double pesoKg;
  final String fotoUrl;
  final String notasMedicas;
  final String estado;       // 'disponible' | 'en_servicio'
  final DateTime createdAt;
}
```

**Notas:**
- `tamanio` afecta el precio final de los servicios
- `estado` se actualiza automáticamente al crear/completar reserva
- `edadTexto` es texto libre para mayor flexibilidad

---

## 3. ServiceModel — `services/{id}`

**Colección Firestore:** `services`

```dart
class ServiceModel {
  final String id;
  final String nombre;
  final String descripcion;
  final ServiceType categoria;  // enum: hospedaje | guarderia | paseo
  final double precioBase;
  final int duracionMin;
  final bool activo;
}
```

**Datos iniciales requeridos:**
| nombre              | categoria  | precioBase | duracionMin |
|---------------------|------------|------------|-------------|
| Hospedaje en Casa   | hospedaje  | 240.0      | 1440        |
| Guardería Diurna    | guarderia  | 180.0      | 480         |
| Paseo Individual    | paseo      | 120.0      | 60          |

---

## 4. BookingModel — `bookings/{id}`

**Colección Firestore:** `bookings`

```dart
class BookingModel {
  final String id;
  final String clientUid;
  final String caregiverUid;
  final String petId;
  final String serviceId;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final BookingStatus estado;   // enum
  final double precioFinal;
  final String notas;
  final DateTime createdAt;

  // Campos denormalizados (opcionales, para mostrar en UI sin joins)
  final String? clienteNombre;
  final String? mascotaNombre;
  final String? servicioNombre;
}
```

**Ciclo de estados:**
```
pendiente → confirmada → en_curso → completada
                    ↘
                   cancelada
```

---

## 5. MessageModel — `chats/{chatId}/messages/{msgId}`

```dart
class MessageModel {
  final String id;
  final String chatId;
  final String senderUid;
  final String text;
  final DateTime timestamp;
  final bool leido;
}
```

---

## 6. ChatModel — `chats/{chatId}`

```dart
class ChatModel {
  final String id;
  final List<String> participants;  // [uid1, uid2]
  final String lastMessage;
  final DateTime updatedAt;

  // Getter helper
  String otherParticipant(String myUid) =>
    participants.firstWhere((p) => p != myUid);
}
```

---

## 7. ReviewModel — `reviews/{id}`

```dart
class ReviewModel {
  final String id;
  final String caregiverUid;
  final String clientUid;
  final String clientNombre;
  final double rating;       // 1.0 - 5.0
  final String comentario;
  final DateTime fecha;
}
```

---

## Enums requeridos

### UserRole (`lib/core/enums/user_role.dart`)
```dart
enum UserRole {
  cliente,
  cuidador,
  admin;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.cliente,
    );
  }

  String get toValue => name;  // 'cliente', 'cuidador', 'admin'
}
```

### BookingStatus (`lib/core/enums/booking_status.dart`)
```dart
enum BookingStatus {
  pendiente,
  confirmada,
  enCurso,
  completada,
  cancelada;

  static BookingStatus fromString(String value) {
    const map = {
      'pendiente': BookingStatus.pendiente,
      'confirmada': BookingStatus.confirmada,
      'en_curso': BookingStatus.enCurso,
      'completada': BookingStatus.completada,
      'cancelada': BookingStatus.cancelada,
    };
    return map[value] ?? BookingStatus.pendiente;
  }

  String get toValue {
    const map = {
      BookingStatus.enCurso: 'en_curso',
    };
    return map[this] ?? name;
  }

  String get label {
    const labels = {
      BookingStatus.pendiente: 'Pendiente',
      BookingStatus.confirmada: 'Confirmada',
      BookingStatus.enCurso: 'En Curso',
      BookingStatus.completada: 'Completada',
      BookingStatus.cancelada: 'Cancelada',
    };
    return labels[this] ?? name;
  }
}
```

### ServiceType (`lib/core/enums/service_type.dart`)
```dart
enum ServiceType {
  hospedaje,
  guarderia,
  paseo;

  static ServiceType fromString(String value) =>
    ServiceType.values.firstWhere((e) => e.name == value,
      orElse: () => ServiceType.guarderia);

  String get toValue => name;

  String get label {
    const labels = {
      ServiceType.hospedaje: 'Hospedaje',
      ServiceType.guarderia: 'Guardería',
      ServiceType.paseo: 'Paseo',
    };
    return labels[this] ?? name;
  }

  String get emoji {
    const emojis = {
      ServiceType.hospedaje: '🏠',
      ServiceType.guarderia: '👥',
      ServiceType.paseo: '🦮',
    };
    return emojis[this] ?? '🐾';
  }
}
```

### PetSize (`lib/core/enums/pet_size.dart`) — AGREGAR este archivo al árbol
```dart
enum PetSize {
  pequenio,
  mediano,
  grande;

  static PetSize fromString(String v) {
    const map = {'pequeño': PetSize.pequenio, 'mediano': PetSize.mediano, 'grande': PetSize.grande};
    return map[v] ?? PetSize.mediano;
  }

  String get toValue {
    const map = {PetSize.pequenio: 'pequeño', PetSize.mediano: 'mediano', PetSize.grande: 'grande'};
    return map[this]!;
  }

  String get label {
    const labels = {PetSize.pequenio: 'Pequeño', PetSize.mediano: 'Mediano', PetSize.grande: 'Grande'};
    return labels[this]!;
  }
}
```
