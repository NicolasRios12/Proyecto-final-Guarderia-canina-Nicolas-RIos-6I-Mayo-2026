# SEED.md — Datos de Prueba para Firestore

## Instrucciones de carga

Los datos de prueba se pueden cargar de dos formas:

### Opción A: Función de seeding en Dart
Crear `lib/data/services/seed_service.dart` que se ejecuta UNA sola vez:

```dart
class SeedService {
  static Future<void> seedAll() async {
    await _seedServices();
    await _seedCaregivers();
    await _seedTestClient();
  }
}
```

Llamar desde `SplashScreen` solo si la colección `services` está vacía:
```dart
final count = await FirebaseFirestore.instance
  .collection('services').count().get();
if (count.count == 0) await SeedService.seedAll();
```

### Opción B: Firestore Console
Crear manualmente los documentos en Firebase Console (ver datos abajo).

---

## Colección: `services`

```json
// Documento ID: hospedaje
{
  "id": "hospedaje",
  "nombre": "Hospedaje en Casa",
  "descripcion": "Cuidado de tu perro en el hogar del cuidador con atención personalizada las 24 horas",
  "categoria": "hospedaje",
  "precio_base": 240,
  "duracion_min": 1440,
  "activo": true
}

// Documento ID: guarderia
{
  "id": "guarderia",
  "nombre": "Guardería Diurna",
  "descripcion": "Cuidado profesional durante el día con actividades y socialización canina",
  "categoria": "guarderia",
  "precio_base": 180,
  "duracion_min": 480,
  "activo": true
}

// Documento ID: paseo
{
  "id": "paseo",
  "nombre": "Paseo Individual",
  "descripcion": "Paseo de 1 hora en parques seguros de la ciudad",
  "categoria": "paseo",
  "precio_base": 120,
  "duracion_min": 60,
  "activo": true
}
```

---

## Colección: `users` — Cuidadores de ejemplo

**IMPORTANTE:** Primero crear las cuentas en Firebase Auth (Email/Password),
luego crear los documentos Firestore con el UID generado.

```
Cuentas Auth a crear en Firebase Console > Authentication:
  paola.martinez@dogclub.com  /  password123
  diana.juarez@dogclub.com    /  password123
  carlos.lopez@dogclub.com    /  password123
```

```json
// Documento: {uid_de_paola}
{
  "uid": "{uid_de_paola}",
  "email": "paola.martinez@dogclub.com",
  "nombre": "Paola",
  "apellido": "Martinez",
  "telefono": "+52 656 123 4567",
  "direccion": "Juárez, Chihuahua",
  "rol": "cuidador",
  "foto_url": "https://i.pravatar.cc/150?img=1",
  "bio": "Amante de los perros con 5 años de experiencia. Sin mascotas propias. Casa con jardín.",
  "activo": true,
  "fecha_registro": "2024-01-15T10:00:00Z"
}

// Documento: {uid_de_diana}
{
  "uid": "{uid_de_diana}",
  "email": "diana.juarez@dogclub.com",
  "nombre": "Diana",
  "apellido": "Juarez",
  "telefono": "+52 656 987 6543",
  "direccion": "Juárez, Chihuahua",
  "rol": "cuidador",
  "foto_url": "https://i.pravatar.cc/150?img=5",
  "bio": "Cuidadora certificada, veterinaria en formación. Experiencia con todas las razas.",
  "activo": true,
  "fecha_registro": "2024-02-20T10:00:00Z"
}

// Documento: {uid_de_carlos}
{
  "uid": "{uid_de_carlos}",
  "email": "carlos.lopez@dogclub.com",
  "nombre": "Carlos",
  "apellido": "Lopez",
  "telefono": "+52 656 555 7890",
  "direccion": "Juárez, Chihuahua",
  "rol": "cuidador",
  "foto_url": "https://i.pravatar.cc/150?img=12",
  "bio": "Especialista en paseos y entrenamiento básico. Disponible todos los días.",
  "activo": true,
  "fecha_registro": "2024-03-10T10:00:00Z"
}
```

---

## Usuario Admin

```
Cuenta Auth: admin@dogclub.com  /  admin123
```

```json
// Documento: {uid_de_admin}
{
  "uid": "{uid_de_admin}",
  "email": "admin@dogclub.com",
  "nombre": "Administrador",
  "apellido": "Dog Club",
  "telefono": "+52 656 000 0000",
  "direccion": "Juárez, Chihuahua",
  "rol": "admin",
  "foto_url": "",
  "bio": "Administrador del sistema Dog Club",
  "activo": true,
  "fecha_registro": "2024-01-01T00:00:00Z"
}
```

---

## Usuario Cliente de prueba

```
Cuenta Auth: cliente1@dogclub.com  /  password123
```

```json
// Documento: {uid_de_cliente1}
{
  "uid": "{uid_de_cliente1}",
  "email": "cliente1@dogclub.com",
  "nombre": "María",
  "apellido": "García",
  "telefono": "+52 656 111 2222",
  "direccion": "Juárez, Chihuahua",
  "rol": "cliente",
  "foto_url": "https://i.pravatar.cc/150?img=25",
  "bio": "",
  "activo": true,
  "fecha_registro": "2024-04-01T10:00:00Z"
}
```

---

## Colección: `pets` — Mascotas de prueba

```json
// Documento ID: pet_charlie
{
  "id": "pet_charlie",
  "owner_uid": "{uid_de_cliente1}",
  "nombre": "Charlie",
  "raza": "Golden Retriever",
  "tamanio": "grande",
  "edad_texto": "6 meses",
  "sexo": "macho",
  "peso_kg": 15.5,
  "foto_url": "https://images.dog.ceo/breeds/retriever-golden/n02099601_1003.jpg",
  "notas_medicas": "Vacunas al día. Sin alergias conocidas.",
  "estado": "disponible",
  "created_at": "2024-04-05T10:00:00Z"
}

// Documento ID: pet_luna
{
  "id": "pet_luna",
  "owner_uid": "{uid_de_cliente1}",
  "nombre": "Luna",
  "raza": "Shih Tzu",
  "tamanio": "pequeño",
  "edad_texto": "3 años, 2 meses",
  "sexo": "hembra",
  "peso_kg": 5.2,
  "foto_url": "https://images.dog.ceo/breeds/shih-tzu/n02086240_181.jpg",
  "notas_medicas": "Alérgica al pasto. Requiere medicamento mensual.",
  "estado": "disponible",
  "created_at": "2024-04-05T11:00:00Z"
}
```

---

## Colección: `reviews` — Reseñas de ejemplo

```json
// Documento ID: review_1
{
  "id": "review_1",
  "caregiver_uid": "{uid_de_paola}",
  "client_uid": "{uid_de_cliente1}",
  "client_nombre": "María García",
  "rating": 5.0,
  "comentario": "Excelente cuidado, mi perro quedó muy feliz. Muy responsable y puntual.",
  "fecha": "2024-05-10T15:00:00Z"
}

// Documento ID: review_2
{
  "id": "review_2",
  "caregiver_uid": "{uid_de_paola}",
  "client_uid": "otro_uid",
  "client_nombre": "Juan López",
  "rating": 4.5,
  "comentario": "Muy buen servicio. Mi bulldog se portó bien y llegó cansado del paseo (perfecto).",
  "fecha": "2024-05-15T12:00:00Z"
}

// Documento ID: review_3
{
  "id": "review_3",
  "caregiver_uid": "{uid_de_diana}",
  "client_uid": "{uid_de_cliente1}",
  "client_nombre": "Ana Torres",
  "rating": 5.0,
  "comentario": "Diana es increíble, envía fotos durante el servicio. Totalmente recomendada.",
  "fecha": "2024-06-01T09:00:00Z"
}
```

---

## SeedService — Código Dart completo

```dart
// lib/data/services/seed_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeedService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Ejecutar solo una vez para inicializar datos de prueba
  static Future<void> seedAll() async {
    try {
      await _seedServices();
      debugPrint('✅ Servicios sembrados');
    } catch (e) {
      debugPrint('❌ Error en seeding: $e');
    }
  }

  static Future<void> _seedServices() async {
    final services = [
      {
        'id': 'hospedaje',
        'nombre': 'Hospedaje en Casa',
        'descripcion': 'Cuidado de tu perro en el hogar del cuidador',
        'categoria': 'hospedaje',
        'precio_base': 240.0,
        'duracion_min': 1440,
        'activo': true,
      },
      {
        'id': 'guarderia',
        'nombre': 'Guardería Diurna',
        'descripcion': 'Cuidado profesional durante el día',
        'categoria': 'guarderia',
        'precio_base': 180.0,
        'duracion_min': 480,
        'activo': true,
      },
      {
        'id': 'paseo',
        'nombre': 'Paseo Individual',
        'descripcion': 'Paseo de 1 hora con tu mascota',
        'categoria': 'paseo',
        'precio_base': 120.0,
        'duracion_min': 60,
        'activo': true,
      },
    ];

    final batch = _db.batch();
    for (final s in services) {
      batch.set(_db.collection('services').doc(s['id'] as String), s);
    }
    await batch.commit();
  }
}
```

---

## Datos hardcodeados para UI (cuando Firestore está vacío)

En `ServiceListScreen`, si no hay cuidadores en Firestore, mostrar estos datos mock:

```dart
// lib/core/constants/mock_data.dart
class MockData {
  static const List<Map<String, dynamic>> caregivers = [
    {
      'nombre': 'Paola',
      'apellido': 'Martinez',
      'foto_url': 'https://i.pravatar.cc/150?img=1',
      'rating': 4.8,
      'reviews': 23,
      'precio': 240,
      'unidad': 'día',
      'ofrece': [
        'Casa con jardín',
        'Fotos diarias',
        'Paseos incluidos',
      ],
    },
    {
      'nombre': 'Diana',
      'apellido': 'Juarez',
      'foto_url': 'https://i.pravatar.cc/150?img=5',
      'rating': 4.9,
      'reviews': 41,
      'precio': 180,
      'unidad': 'día',
      'ofrece': [
        'Sin otras mascotas',
        'Actualizaciones en tiempo real',
        'Veterinaria en formación',
      ],
    },
    {
      'nombre': 'Carlos',
      'apellido': 'Lopez',
      'foto_url': 'https://i.pravatar.cc/150?img=12',
      'rating': 4.6,
      'reviews': 17,
      'precio': 120,
      'unidad': 'hora',
      'ofrece': [
        'Rutas seguras',
        'GPS tracking',
        'Entrenamiento básico',
      ],
    },
  ];

  static const List<Map<String, dynamic>> mockReviews = [
    {
      'nombre': 'María G.',
      'rating': 5.0,
      'comentario': 'Excelente cuidado, muy responsable.',
      'fecha': 'hace 2 días',
    },
    {
      'nombre': 'Juan L.',
      'rating': 4.5,
      'comentario': 'Mi perro quedó muy contento.',
      'fecha': 'hace 1 semana',
    },
    {
      'nombre': 'Ana T.',
      'rating': 5.0,
      'comentario': 'Envía fotos constantemente. 100% recomendada.',
      'fecha': 'hace 2 semanas',
    },
  ];
}
```
