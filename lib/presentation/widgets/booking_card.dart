import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/booking_model.dart';
import '../../core/utils/date_helper.dart';
import 'status_badge.dart';

/// Card de reserva usada en la lista de solicitudes del cuidador y el historial.
/// Muestra mascota, servicio, fecha, precio y botones de acción opcionales.
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onAceptar;
  final VoidCallback? onRechazar;

  const BookingCard({
    super.key,
    required this.booking,
    this.onAceptar,
    this.onRechazar,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: mascota + servicio + estado
          Row(
            children: [
              const Icon(Icons.pets, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.mascotaNombre ?? 'Mascota',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(booking.servicioNombre ?? 'Servicio',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              StatusBadge(status: booking.estado),
            ],
          ),
          const Divider(height: 20),
          // Fecha y precio
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(DateHelper.formatDateTime(booking.fechaInicio),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const Spacer(),
              Text('\$${booking.precioFinal.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16)),
            ],
          ),
          // Botones de acción (solo para cuidador en solicitudes pendientes)
          if (onAceptar != null || onRechazar != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (onRechazar != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRechazar,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Rechazar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                if (onAceptar != null && onRechazar != null)
                  const SizedBox(width: 12),
                if (onAceptar != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onAceptar,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Aceptar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
