import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/pet_size.dart';

/// Modelo de mascota de Dog Club.
/// Colección Firestore: `pets` (colección raíz).
/// Documento ID: UUID generado con paquete `uuid`.
class PetModel {
  final String id;
  final String ownerUid;
  final String nombre;
  final String raza;
  final PetSize tamanio;
  final String edadTexto;
  final String sexo;
  final double pesoKg;
  final String fotoUrl;
  final String notasMedicas;
  final String estado; // 'disponible' | 'en_servicio'
  final DateTime createdAt;

  const PetModel({
    required this.id,
    required this.ownerUid,
    required this.nombre,
    required this.raza,
    required this.tamanio,
    required this.edadTexto,
    required this.sexo,
    required this.pesoKg,
    required this.fotoUrl,
    required this.notasMedicas,
    required this.estado,
    required this.createdAt,
  });

  /// Crea un PetModel desde un mapa de Firestore.
  factory PetModel.fromMap(Map<String, dynamic> map, String id) {
    return PetModel(
      id: id,
      ownerUid: map['owner_uid'] as String? ?? '',
      nombre: map['nombre'] as String? ?? '',
      raza: map['raza'] as String? ?? '',
      tamanio: PetSize.fromString(map['tamanio'] as String? ?? 'mediano'),
      edadTexto: map['edad_texto'] as String? ?? '',
      sexo: map['sexo'] as String? ?? 'macho',
      pesoKg: (map['peso_kg'] as num?)?.toDouble() ?? 0.0,
      fotoUrl: map['foto_url'] as String? ?? '',
      notasMedicas: map['notas_medicas'] as String? ?? '',
      estado: map['estado'] as String? ?? 'disponible',
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : DateTime.tryParse(map['created_at']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_uid': ownerUid,
      'nombre': nombre,
      'raza': raza,
      'tamanio': tamanio.toValue,
      'edad_texto': edadTexto,
      'sexo': sexo,
      'peso_kg': pesoKg,
      'foto_url': fotoUrl,
      'notas_medicas': notasMedicas,
      'estado': estado,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  /// Crea una copia del modelo con campos modificados.
  PetModel copyWith({
    String? id,
    String? ownerUid,
    String? nombre,
    String? raza,
    PetSize? tamanio,
    String? edadTexto,
    String? sexo,
    double? pesoKg,
    String? fotoUrl,
    String? notasMedicas,
    String? estado,
    DateTime? createdAt,
  }) {
    return PetModel(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      nombre: nombre ?? this.nombre,
      raza: raza ?? this.raza,
      tamanio: tamanio ?? this.tamanio,
      edadTexto: edadTexto ?? this.edadTexto,
      sexo: sexo ?? this.sexo,
      pesoKg: pesoKg ?? this.pesoKg,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      notasMedicas: notasMedicas ?? this.notasMedicas,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
