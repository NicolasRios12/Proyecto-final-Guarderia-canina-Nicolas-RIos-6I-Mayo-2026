import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/booking_status.dart';
import '../../../core/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_shimmer.dart';

/// Pantalla de solicitudes pendientes del cuidador.
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  Future<void> _aceptarReserva(BookingModel booking) async {
    try {
      await BookingRepository()
          .updateStatus(booking.id, BookingStatus.confirmada);
      await PetRepository().updateStatus(booking.petId, 'en_servicio');
      await ChatRepository().getOrCreateChat(
        uid1: booking.caregiverUid,
        uid2: booking.clientUid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Reserva aceptada'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al aceptar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _rechazarReserva(BookingModel booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: const Text('¿Estás seguro de rechazar esta solicitud?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Rechazar')),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await BookingRepository()
          .updateStatus(booking.id, BookingStatus.cancelada);
      await PetRepository().updateStatus(booking.petId, 'disponible');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud rechazada')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes Pendientes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingRepository()
            .getPendingForCaregiver(auth.currentUser!.uid),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snap.hasError) {
            return const EmptyState(
                message: 'Error al cargar solicitudes',
                icon: Icons.error_outline);
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const EmptyState(
              message: 'Sin solicitudes pendientes',
              icon: Icons.inbox_outlined,
            );
          }

          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final booking = snap.data![i];
              return BookingCard(
                booking: booking,
                onAceptar: () => _aceptarReserva(booking),
                onRechazar: () => _rechazarReserva(booking),
              );
            },
          );
        },
      ),
    );
  }
}
