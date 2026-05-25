import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../../core/enums/booking_status.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_shimmer.dart';

/// Pantalla principal del cuidador con estadísticas y solicitudes pendientes.
class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUser != null) {
        context
            .read<BookingProvider>()
            .startListeningCaregiver(auth.currentUser!.uid);
      }
    });
  }

  Future<void> _aceptarReserva(BookingModel booking) async {
    try {
      // 1. Actualizar estado de la reserva
      await BookingRepository()
          .updateStatus(booking.id, BookingStatus.confirmada);

      // 2. Actualizar estado de la mascota
      await PetRepository().updateStatus(booking.petId, 'en_servicio');

      // 3. Crear chat automáticamente si no existe
      await ChatRepository().getOrCreateChat(
        uid1: booking.caregiverUid,
        uid2: booking.clientUid,
      );

      // 4. Feedback al usuario
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
    // Confirmar antes de rechazar
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content:
            const Text('¿Estás seguro de rechazar esta solicitud?'),
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
            content: Text('Error al rechazar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidador'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push('/caregiver/chat/list'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Pendientes',
                      value: '${bookingProvider.pendingCount}',
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Activas Hoy',
                      value: '${bookingProvider.activeToday.length}',
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Ganancias',
                      value:
                          '\$${bookingProvider.monthEarnings.toStringAsFixed(0)}',
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            // Accesos rápidos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.pending_actions,
                      label: 'Solicitudes',
                      onTap: () => context.push('/caregiver/requests'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.pets,
                      label: 'Mascotas Activas',
                      onTap: () => context.push('/caregiver/active-pets'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.person,
                      label: 'Mi Perfil',
                      onTap: () => context.push('/caregiver/profile'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Solicitudes pendientes
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Solicitudes Pendientes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<BookingModel>>(
              stream: BookingRepository()
                  .getPendingForCaregiver(auth.currentUser!.uid),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const LoadingShimmer(itemCount: 3);
                }
                if (snap.hasError) {
                  return const EmptyState(
                      message: 'Error al cargar solicitudes',
                      icon: Icons.error_outline);
                }
                if (!snap.hasData || snap.data!.isEmpty) {
                  return const EmptyState(
                    message: 'Sin solicitudes pendientes',
                    subtitle: 'Las nuevas solicitudes aparecerán aquí',
                    icon: Icons.inbox_outlined,
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Card de estadística con color, valor y etiqueta.
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Botón de acceso rápido con ícono y etiqueta.
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
