import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/enums/booking_status.dart';

/// Badge de estado de reserva con colores diferenciados.
class StatusBadge extends StatelessWidget {
  final BookingStatus status;

  const StatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case BookingStatus.pendiente:
        return AppColors.pendienteBg;
      case BookingStatus.confirmada:
        return AppColors.confirmadaBg;
      case BookingStatus.enCurso:
        return AppColors.enCursoBg;
      case BookingStatus.completada:
        return AppColors.completadaBg;
      case BookingStatus.cancelada:
        return AppColors.canceladaBg;
    }
  }

  Color get _textColor {
    switch (status) {
      case BookingStatus.pendiente:
        return AppColors.pendienteText;
      case BookingStatus.confirmada:
        return AppColors.confirmadaText;
      case BookingStatus.enCurso:
        return AppColors.enCursoText;
      case BookingStatus.completada:
        return AppColors.completadaText;
      case BookingStatus.cancelada:
        return AppColors.canceladaText;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: _bgColor,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      status.label,
      style: TextStyle(
        color: _textColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
