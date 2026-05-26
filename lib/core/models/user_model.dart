import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/user_role.dart';

/// Modelo de usuario de Dog Club.
/// Colección Firestore: `users` — Documento ID: UID de Firebase Auth.
class UserModel {
  final String uid;
  final String email;
  final String nombre;
  final String apellido;
  final String telefono;
  final String direccion;
  final UserRole rol;
  final String fotoUrl;
  final String backgroundImg;
  final String bio;
  final DateTime fechaRegistro;
  final bool activo;

  const UserModel({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.direccion,
    required this.rol,
    required this.fotoUrl,
    this.backgroundImg = '',
    required this.bio,
    required this.fechaRegistro,
    required this.activo,
  });

  /// Nombre completo del usuario.
  String get nombreCompleto => '$nombre $apellido';

  /// Crea un UserModel desde un mapa de Firestore.
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] as String? ?? '',
      nombre: map['nombre'] as String? ?? '',
      apellido: map['apellido'] as String? ?? '',
      telefono: map['telefono'] as String? ?? '',
      direccion: map['direccion'] as String? ?? '',
      rol: UserRole.fromString(map['rol'] as String? ?? 'cliente'),
      fotoUrl: map['foto_url'] as String? ?? '',
      backgroundImg: map['background_img'] as String? ?? '',
      bio: map['bio'] as String? ?? '',
      fechaRegistro: map['fecha_registro'] is Timestamp
          ? (map['fecha_registro'] as Timestamp).toDate()
          : DateTime.tryParse(map['fecha_registro']?.toString() ?? '') ??
              DateTime.now(),
      activo: map['activo'] as bool? ?? true,
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'direccion': direccion,
      'rol': rol.toValue,
      'foto_url': fotoUrl,
      'background_img': backgroundImg,
      'bio': bio,
      'fecha_registro': Timestamp.fromDate(fechaRegistro),
      'activo': activo,
    };
  }

  /// Crea una copia del modelo con campos modificados.
  UserModel copyWith({
    String? uid,
    String? email,
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
    UserRole? rol,
    String? fotoUrl,
    String? backgroundImg,
    String? bio,
    DateTime? fechaRegistro,
    bool? activo,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      rol: rol ?? this.rol,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      backgroundImg: backgroundImg ?? this.backgroundImg,
      bio: bio ?? this.bio,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      activo: activo ?? this.activo,
    );
  }
}
