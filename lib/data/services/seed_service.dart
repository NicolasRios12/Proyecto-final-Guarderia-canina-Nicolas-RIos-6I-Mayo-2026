import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Servicio de datos semilla (seed) para inicializar Firestore con datos de prueba realistas.
/// Se ejecuta desde SplashScreen si la colección de servicios o de usuarios está vacía.
class SeedService {
  static final _db = FirebaseFirestore.instance;

  /// Ejecuta el sembrado completo de la base de datos de manera secuencial y segura.
  static Future<void> seedAll() async {
    try {
      await _seedServices();
      debugPrint('✅ Servicios sembrados');
      
      await _seedUsers();
      debugPrint('✅ Usuarios sembrados');
      
      await _seedPets();
      debugPrint('✅ Mascotas sembradas');
      
      await _seedBookings();
      debugPrint('✅ Reservas sembradas');
      
      await _seedChats();
      debugPrint('✅ Conversaciones de chat sembradas');
      
      debugPrint('🎉 ¡Base de datos completamente sembrada con éxito!');
    } catch (e) {
      debugPrint('❌ Error general durante el seeding de base de datos: $e');
    }
  }

  /// Siembra los 3 servicios base en la colección `services`.
  static Future<void> _seedServices() async {
    final services = [
      {
        'id': 'hospedaje',
        'nombre': 'Hospedaje en Casa',
        'descripcion':
            'Cuidado de tu perro en el hogar del cuidador con atención personalizada las 24 horas',
        'categoria': 'hospedaje',
        'precio_base': 240.0,
        'duracion_min': 1440,
        'activo': true,
      },
      {
        'id': 'guarderia',
        'nombre': 'Guardería Diurna',
        'descripcion':
            'Cuidado profesional durante el día con actividades y socialización canina',
        'categoria': 'guarderia',
        'precio_base': 180.0,
        'duracion_min': 480,
        'activo': true,
      },
      {
        'id': 'paseo',
        'nombre': 'Paseo Individual',
        'descripcion': 'Paseo de 1 hora en parques seguros de la ciudad',
        'categoria': 'paseo',
        'precio_base': 120.0,
        'duracion_min': 60,
        'activo': true,
      },
    ];

    final batch = _db.batch();
    for (final s in services) {
      batch.set(_db.collection('services').doc(s['id'] as String), s, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// Siembra usuarios con roles predefinidos (cuidadores, clientes y admin).
  static Future<void> _seedUsers() async {
    final users = [
      {
        'uid': 'admin_dogclub',
        'email': 'admin@dogclub.com',
        'nombre': 'Administrador',
        'apellido': 'Dog Club',
        'telefono': '+52 656 000 0000',
        'direccion': 'Juárez, Chihuahua',
        'rol': 'admin',
        'foto_url': '',
        'bio': 'Administrador del sistema Dog Club',
        'activo': true,
        'fecha_registro': Timestamp.now(),
      },
      {
        'uid': 'cuidador_paola',
        'email': 'paola.martinez@dogclub.com',
        'nombre': 'Paola',
        'apellido': 'Martinez',
        'telefono': '+52 656 123 4567',
        'direccion': 'Juárez, Chihuahua',
        'rol': 'cuidador',
        'foto_url': 'https://i.pravatar.cc/150?img=1',
        'background_img': 'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&q=80&w=600',
        'bio': 'Amante de los perros con 5 años de experiencia. Sin mascotas propias. Casa con jardín grande.',
        'activo': true,
        'fecha_registro': Timestamp.now(),
      },
      {
        'uid': 'cuidador_diana',
        'email': 'diana.juarez@dogclub.com',
        'nombre': 'Diana',
        'apellido': 'Juarez',
        'telefono': '+52 656 987 6543',
        'direccion': 'Juárez, Chihuahua',
        'rol': 'cuidador',
        'foto_url': 'https://i.pravatar.cc/150?img=5',
        'background_img': 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&q=80&w=600',
        'bio': 'Cuidadora certificada, veterinaria en formación. Experiencia con todas las razas.',
        'activo': true,
        'fecha_registro': Timestamp.now(),
      },
      {
        'uid': 'cuidador_carlos',
        'email': 'carlos.lopez@dogclub.com',
        'nombre': 'Carlos',
        'apellido': 'Lopez',
        'telefono': '+52 656 555 7890',
        'direccion': 'Juárez, Chihuahua',
        'rol': 'cuidador',
        'foto_url': 'https://i.pravatar.cc/150?img=12',
        'background_img': 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&q=80&w=600',
        'bio': 'Especialista en paseos y entrenamiento básico de socialización. Disponible todos los días.',
        'activo': true,
        'fecha_registro': Timestamp.now(),
      },
      {
        'uid': 'cliente_maria',
        'email': 'cliente1@dogclub.com',
        'nombre': 'María',
        'apellido': 'García',
        'telefono': '+52 656 111 2222',
        'direccion': 'Juárez, Chihuahua',
        'rol': 'cliente',
        'foto_url': 'https://i.pravatar.cc/150?img=25',
        'bio': 'Madre cariñosa de dos hermosos perritos, Charlie y Luna.',
        'activo': true,
        'fecha_registro': Timestamp.now(),
      },
      {
        'uid': 'cliente_pedro',
        'email': 'pedro.ortiz@dogclub.com',
        'nombre': 'Pedro',
        'apellido': 'Ortiz',
        'telefono': '+52 656 777 8888',
        'direccion': 'Juárez, Chihuahua',
        'rol': 'cliente',
        'foto_url': 'https://i.pravatar.cc/150?img=33',
        'bio': 'Apasionado del senderismo y de las actividades al aire libre con Toby y Rocky.',
        'activo': true,
        'fecha_registro': Timestamp.now(),
      },
    ];

    final batch = _db.batch();
    for (final u in users) {
      batch.set(_db.collection('users').doc(u['uid'] as String), u, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// Siembra mascotas de prueba asociadas a los clientes ficticios.
  static Future<void> _seedPets() async {
    final pets = [
      {
        'id': 'pet_charlie',
        'owner_uid': 'cliente_maria',
        'nombre': 'Charlie',
        'raza': 'Golden Retriever',
        'tamanio': 'grande',
        'edad_texto': '6 meses',
        'sexo': 'macho',
        'peso_kg': 15.5,
        'foto_url': 'https://images.dog.ceo/breeds/retriever-golden/n02099601_1003.jpg',
        'notas_medicas': 'Vacunas al día. Sin alergias conocidas.',
        'estado': 'disponible',
        'created_at': Timestamp.now(),
      },
      {
        'id': 'pet_luna',
        'owner_uid': 'cliente_maria',
        'nombre': 'Luna',
        'raza': 'Shih Tzu',
        'tamanio': 'pequeño',
        'edad_texto': '3 años, 2 meses',
        'sexo': 'hembra',
        'peso_kg': 5.2,
        'foto_url': 'https://images.dog.ceo/breeds/shih-tzu/n02086240_181.jpg',
        'notas_medicas': 'Alérgica al pasto. Requiere medicamento mensual.',
        'estado': 'disponible',
        'created_at': Timestamp.now(),
      },
      {
        'id': 'pet_toby',
        'owner_uid': 'cliente_pedro',
        'nombre': 'Toby',
        'raza': 'Beagle',
        'tamanio': 'mediano',
        'edad_texto': '1 año',
        'sexo': 'macho',
        'peso_kg': 10.0,
        'foto_url': 'https://images.dog.ceo/breeds/beagle/n02088303_115.jpg',
        'notas_medicas': 'Muy juguetón. Todas las vacunas en orden.',
        'estado': 'disponible',
        'created_at': Timestamp.now(),
      },
      {
        'id': 'pet_rocky',
        'owner_uid': 'cliente_pedro',
        'nombre': 'Rocky',
        'raza': 'Pastor Alemán',
        'tamanio': 'grande',
        'edad_texto': '4 años',
        'sexo': 'macho',
        'peso_kg': 32.0,
        'foto_url': 'https://images.dog.ceo/breeds/germanshepherd/n02106662_6065.jpg',
        'notas_medicas': 'Propenso a la displasia de cadera. Cuidado con saltos de gran altura.',
        'estado': 'disponible',
        'created_at': Timestamp.now(),
      },
    ];

    final batch = _db.batch();
    for (final p in pets) {
      batch.set(_db.collection('pets').doc(p['id'] as String), p, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// Siembra reservas con diferentes cuidadores y estados de prueba.
  static Future<void> _seedBookings() async {
    final bookings = [
      {
        'id': 'booking_charlie_paola',
        'client_uid': 'cliente_maria',
        'caregiver_uid': 'cuidador_paola',
        'pet_id': 'pet_charlie',
        'service_id': 'hospedaje',
        'fecha_inicio': Timestamp.fromDate(DateTime.now().add(const Duration(days: 2))),
        'fecha_fin': Timestamp.fromDate(DateTime.now().add(const Duration(days: 4))),
        'estado': 'confirmada',
        'precio_final': 480.0,
        'notas': 'Llevar sus juguetes favoritos y su croqueta especial de cordero.',
        'created_at': Timestamp.now(),
        'cliente_nombre': 'María García',
        'mascota_nombre': 'Charlie',
        'servicio_nombre': 'Hospedaje en Casa',
      },
      {
        'id': 'booking_luna_diana',
        'client_uid': 'cliente_maria',
        'caregiver_uid': 'cuidador_diana',
        'pet_id': 'pet_luna',
        'service_id': 'guarderia',
        'fecha_inicio': Timestamp.fromDate(DateTime.now().add(const Duration(days: 1))),
        'fecha_fin': Timestamp.fromDate(DateTime.now().add(const Duration(days: 1, hours: 8))),
        'estado': 'pendiente',
        'precio_final': 180.0,
        'notas': 'Es un poco nerviosa al principio con otros perritos.',
        'created_at': Timestamp.now(),
        'cliente_nombre': 'María García',
        'mascota_nombre': 'Luna',
        'servicio_nombre': 'Guardería Diurna',
      },
      {
        'id': 'booking_toby_carlos',
        'client_uid': 'cliente_pedro',
        'caregiver_uid': 'cuidador_carlos',
        'pet_id': 'pet_toby',
        'service_id': 'paseo',
        'fecha_inicio': Timestamp.fromDate(DateTime.now()),
        'fecha_fin': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 1))),
        'estado': 'en_curso',
        'precio_final': 120.0,
        'notas': 'Pasear con correa corta porque es sumamente curioso.',
        'created_at': Timestamp.now(),
        'cliente_nombre': 'Pedro Ortiz',
        'mascota_nombre': 'Toby',
        'servicio_nombre': 'Paseo Individual',
      },
      {
        'id': 'booking_rocky_paola',
        'client_uid': 'cliente_pedro',
        'caregiver_uid': 'cuidador_paola',
        'pet_id': 'pet_rocky',
        'service_id': 'hospedaje',
        'fecha_inicio': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 5))),
        'fecha_fin': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
        'estado': 'completada',
        'precio_final': 720.0,
        'notas': 'Darle de comer dos veces al día. Requiere bastante agua fresca.',
        'created_at': Timestamp.now(),
        'cliente_nombre': 'Pedro Ortiz',
        'mascota_nombre': 'Rocky',
        'servicio_nombre': 'Hospedaje en Casa',
      },
    ];

    final batch = _db.batch();
    for (final b in bookings) {
      batch.set(_db.collection('bookings').doc(b['id'] as String), b, SetOptions(merge: true));
    }
    await batch.commit();
  }

  /// Siembra canales de chat y sus respectivos mensajes en Firestore.
  static Future<void> _seedChats() async {
    // Definir conversaciones principales
    final chat1 = {
      'id': 'chat_maria_paola',
      'participants': ['cliente_maria', 'cuidador_paola'],
      'last_message': 'Excelente, ¡muchas gracias por cuidarlo tan bien!',
      'updated_at': Timestamp.now(),
    };
    final chat2 = {
      'id': 'chat_maria_diana',
      'participants': ['cliente_maria', 'cuidador_diana'],
      'last_message': 'Hola Diana, te mandé una solicitud para mañana.',
      'updated_at': Timestamp.now(),
    };
    final chat3 = {
      'id': 'chat_pedro_carlos',
      'participants': ['cliente_pedro', 'cuidador_carlos'],
      'last_message': 'Toby ya está listo para su paseo!',
      'updated_at': Timestamp.now(),
    };

    final batch = _db.batch();
    batch.set(_db.collection('chats').doc(chat1['id'] as String), chat1, SetOptions(merge: true));
    batch.set(_db.collection('chats').doc(chat2['id'] as String), chat2, SetOptions(merge: true));
    batch.set(_db.collection('chats').doc(chat3['id'] as String), chat3, SetOptions(merge: true));
    await batch.commit();

    // Mensajes para chat 1
    final messagesChat1 = [
      {
        'id': 'msg1_1',
        'chat_id': 'chat_maria_paola',
        'sender_uid': 'cliente_maria',
        'text': 'Hola Paola, ¿cómo está Charlie hoy?',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 30))),
        'leido': true,
      },
      {
        'id': 'msg1_2',
        'chat_id': 'chat_maria_paola',
        'sender_uid': 'cuidador_paola',
        'text': 'Hola María! Charlie está súper bien, acabamos de regresar de su paseo de la tarde.',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 15))),
        'leido': true,
      },
      {
        'id': 'msg1_3',
        'chat_id': 'chat_maria_paola',
        'sender_uid': 'cliente_maria',
        'text': 'Excelente, ¡muchas gracias por cuidarlo tan bien!',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 5))),
        'leido': false,
      },
    ];

    // Mensajes para chat 2
    final messagesChat2 = [
      {
        'id': 'msg2_1',
        'chat_id': 'chat_maria_diana',
        'sender_uid': 'cliente_maria',
        'text': 'Hola Diana, te mandé una solicitud para mañana.',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
        'leido': true,
      },
    ];

    // Mensajes para chat 3
    final messagesChat3 = [
      {
        'id': 'msg3_1',
        'chat_id': 'chat_pedro_carlos',
        'sender_uid': 'cuidador_carlos',
        'text': 'Hola Pedro, estoy por llegar a tu domicilio por Toby.',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 10))),
        'leido': true,
      },
      {
        'id': 'msg3_2',
        'chat_id': 'chat_pedro_carlos',
        'sender_uid': 'cliente_pedro',
        'text': 'Toby ya está listo para su paseo!',
        'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 8))),
        'leido': false,
      },
    ];

    final batchMessages = _db.batch();
    for (var m in messagesChat1) {
      batchMessages.set(
        _db.collection('chats').doc('chat_maria_paola').collection('messages').doc(m['id'] as String),
        m,
        SetOptions(merge: true),
      );
    }
    for (var m in messagesChat2) {
      batchMessages.set(
        _db.collection('chats').doc('chat_maria_diana').collection('messages').doc(m['id'] as String),
        m,
        SetOptions(merge: true),
      );
    }
    for (var m in messagesChat3) {
      batchMessages.set(
        _db.collection('chats').doc('chat_pedro_carlos').collection('messages').doc(m['id'] as String),
        m,
        SetOptions(merge: true),
      );
    }
    await batchMessages.commit();
  }
}
