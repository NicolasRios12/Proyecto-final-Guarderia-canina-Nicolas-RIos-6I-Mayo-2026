import '../enums/service_type.dart';

/// Modelo de servicio ofrecido en Dog Club.
/// Colección Firestore: `services`.
class ServiceModel {
  final String id;
  final String nombre;
  final String descripcion;
  final ServiceType categoria;
  final double precioBase;
  final int duracionMin;
  final bool activo;

  const ServiceModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precioBase,
    required this.duracionMin,
    required this.activo,
  });

  /// Crea un ServiceModel desde un mapa de Firestore.
  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      nombre: map['nombre'] as String? ?? '',
      descripcion: map['descripcion'] as String? ?? '',
      categoria: ServiceType.fromString(map['categoria'] as String? ?? 'guarderia'),
      precioBase: (map['precio_base'] as num?)?.toDouble() ?? 0.0,
      duracionMin: (map['duracion_min'] as num?)?.toInt() ?? 0,
      activo: map['activo'] as bool? ?? true,
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria.toValue,
      'precio_base': precioBase,
      'duracion_min': duracionMin,
      'activo': activo,
    };
  }

  /// Crea una copia del modelo con campos modificados.
  ServiceModel copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    ServiceType? categoria,
    double? precioBase,
    int? duracionMin,
    bool? activo,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      precioBase: precioBase ?? this.precioBase,
      duracionMin: duracionMin ?? this.duracionMin,
      activo: activo ?? this.activo,
    );
  }
}
