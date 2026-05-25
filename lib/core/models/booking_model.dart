import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/booking_status.dart';

/// Modelo de reserva de Dog Club.
/// Colección Firestore: `bookings`.
class BookingModel {
  final String id;
  final String clientUid;
  final String caregiverUid;
  final String petId;
  final String serviceId;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final BookingStatus estado;
  final double precioFinal;
  final String notas;
  final DateTime createdAt;

  // Campos denormalizados para mostrar en UI sin joins
  final String? clienteNombre;
  final String? mascotaNombre;
  final String? servicioNombre;

  const BookingModel({
    required this.id,
    required this.clientUid,
    required this.caregiverUid,
    required this.petId,
    required this.serviceId,
    required this.fechaInicio,
    this.fechaFin,
    required this.estado,
    required this.precioFinal,
    required this.notas,
    required this.createdAt,
    this.clienteNombre,
    this.mascotaNombre,
    this.servicioNombre,
  });

  /// Crea un BookingModel desde un mapa de Firestore.
  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      clientUid: map['client_uid'] as String? ?? '',
      caregiverUid: map['caregiver_uid'] as String? ?? '',
      petId: map['pet_id'] as String? ?? '',
      serviceId: map['service_id'] as String? ?? '',
      fechaInicio: map['fecha_inicio'] is Timestamp
          ? (map['fecha_inicio'] as Timestamp).toDate()
          : DateTime.tryParse(map['fecha_inicio']?.toString() ?? '') ??
              DateTime.now(),
      fechaFin: map['fecha_fin'] is Timestamp
          ? (map['fecha_fin'] as Timestamp).toDate()
          : map['fecha_fin'] != null
              ? DateTime.tryParse(map['fecha_fin'].toString())
              : null,
      estado: BookingStatus.fromString(map['estado'] as String? ?? 'pendiente'),
      precioFinal: (map['precio_final'] as num?)?.toDouble() ?? 0.0,
      notas: map['notas'] as String? ?? '',
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : DateTime.tryParse(map['created_at']?.toString() ?? '') ??
              DateTime.now(),
      clienteNombre: map['cliente_nombre'] as String?,
      mascotaNombre: map['mascota_nombre'] as String?,
      servicioNombre: map['servicio_nombre'] as String?,
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_uid': clientUid,
      'caregiver_uid': caregiverUid,
      'pet_id': petId,
      'service_id': serviceId,
      'fecha_inicio': Timestamp.fromDate(fechaInicio),
      'fecha_fin': fechaFin != null ? Timestamp.fromDate(fechaFin!) : null,
      'estado': estado.toValue,
      'precio_final': precioFinal,
      'notas': notas,
      'created_at': Timestamp.fromDate(createdAt),
      if (clienteNombre != null) 'cliente_nombre': clienteNombre,
      if (mascotaNombre != null) 'mascota_nombre': mascotaNombre,
      if (servicioNombre != null) 'servicio_nombre': servicioNombre,
    };
  }

  /// Crea una copia del modelo con campos modificados.
  BookingModel copyWith({
    String? id,
    String? clientUid,
    String? caregiverUid,
    String? petId,
    String? serviceId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    BookingStatus? estado,
    double? precioFinal,
    String? notas,
    DateTime? createdAt,
    String? clienteNombre,
    String? mascotaNombre,
    String? servicioNombre,
  }) {
    return BookingModel(
      id: id ?? this.id,
      clientUid: clientUid ?? this.clientUid,
      caregiverUid: caregiverUid ?? this.caregiverUid,
      petId: petId ?? this.petId,
      serviceId: serviceId ?? this.serviceId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      precioFinal: precioFinal ?? this.precioFinal,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      mascotaNombre: mascotaNombre ?? this.mascotaNombre,
      servicioNombre: servicioNombre ?? this.servicioNombre,
    );
  }
}
