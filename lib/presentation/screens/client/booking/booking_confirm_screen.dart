import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/booking_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/outlined_button.dart';

/// Pantalla de confirmación de reserva exitosa.
class BookingConfirmScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingConfirmScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de éxito
              const Icon(Icons.check_circle,
                  size: 80, color: AppColors.success),
              const SizedBox(height: 16),
              const Text('¡Reserva confirmada!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Tu reserva ha sido enviada al cuidador',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Card con detalles
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _DetailRow(
                          icon: Icons.pets,
                          label: 'Mascota',
                          value: booking.mascotaNombre ?? 'No especificada'),
                      const Divider(),
                      _DetailRow(
                          icon: Icons.miscellaneous_services,
                          label: 'Servicio',
                          value: booking.servicioNombre ?? 'No especificado'),
                      const Divider(),
                      _DetailRow(
                          icon: Icons.calendar_today,
                          label: 'Fecha',
                          value:
                              DateHelper.formatDateTime(booking.fechaInicio)),
                      const Divider(),
                      _DetailRow(
                          icon: Icons.attach_money,
                          label: 'Precio',
                          value:
                              '\$${booking.precioFinal.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botones de acción
              PrimaryButton(
                label: 'Ir al inicio',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 12),
              AppOutlinedButton(
                label: 'Ver mis chats',
                onPressed: () => context.go('/home/chats'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fila de detalle con ícono, etiqueta y valor.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14)),
          const Spacer(),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
