import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/enums/booking_status.dart';
import '../../core/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

/// Provider de estado global para reservas.
/// Escucha cambios en Firestore tanto para clientes como cuidadores.
class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepo = BookingRepository();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  StreamSubscription? _sub;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;

  /// Cantidad de reservas pendientes.
  int get pendingCount =>
      _bookings.where((b) => b.estado == BookingStatus.pendiente).length;

  /// Reservas activas (confirmadas o en curso).
  List<BookingModel> get activeToday {
    return _bookings
        .where((b) =>
            b.estado == BookingStatus.confirmada ||
            b.estado == BookingStatus.enCurso)
        .toList();
  }

  /// Ganancias del mes actual (solo reservas completadas).
  double get monthEarnings {
    final now = DateTime.now();
    return _bookings
        .where((b) =>
            b.estado == BookingStatus.completada &&
            b.fechaInicio.month == now.month &&
            b.fechaInicio.year == now.year)
        .fold(0.0, (sum, b) => sum + b.precioFinal);
  }

  /// Inicia la escucha de reservas del cliente.
  void startListeningClient(String clientUid) {
    _sub?.cancel();
    _sub = _bookingRepo.getClientBookings(clientUid).listen(
      (bookings) {
        _bookings = bookings;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error en stream de reservas cliente: $e');
      },
    );
  }

  /// Inicia la escucha de todas las reservas del cuidador.
  void startListeningCaregiver(String caregiverUid) {
    _sub?.cancel();
    _sub = _bookingRepo.getAllForCaregiver(caregiverUid).listen(
      (bookings) {
        _bookings = bookings;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error en stream de reservas cuidador: $e');
      },
    );
  }

  /// Crea una nueva reserva con estado pendiente.
  Future<BookingModel> createBooking({
    required String clientUid,
    required String caregiverUid,
    required String petId,
    required String serviceId,
    required DateTime fechaInicio,
    required double precioFinal,
    String notas = '',
    String? clienteNombre,
    String? mascotaNombre,
    String? servicioNombre,
  }) async {
    try {
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
        clienteNombre: clienteNombre,
        mascotaNombre: mascotaNombre,
        servicioNombre: servicioNombre,
      );

      await _bookingRepo.createBooking(booking);
      return booking;
    } catch (e) {
      throw Exception('Error al crear reserva: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
