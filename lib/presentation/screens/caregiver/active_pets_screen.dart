import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/booking_status.dart';
import '../../../core/models/booking_model.dart';
import '../../../core/models/pet_model.dart';
import '../../../core/utils/date_helper.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/pet_repository.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/status_badge.dart';

/// Pantalla de mascotas activas en servicio del cuidador.
class ActivePetsScreen extends StatelessWidget {
  const ActivePetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas Activas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingRepository()
            .getActiveForCaregiver(auth.currentUser!.uid),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snap.hasError) {
            return const EmptyState(
                message: 'Error al cargar mascotas activas',
                icon: Icons.error_outline);
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const EmptyState(
              message: 'Sin mascotas activas',
              subtitle: 'Las mascotas en servicio aparecerán aquí',
              icon: Icons.pets,
            );
          }

          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final booking = snap.data![i];
              return _ActivePetCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

/// Card de mascota activa con información de la reserva.
class _ActivePetCard extends StatelessWidget {
  final BookingModel booking;

  const _ActivePetCard({required this.booking});

  Future<void> _iniciarServicio(BuildContext context) async {
    try {
      await BookingRepository().updateStatus(booking.id, BookingStatus.enCurso);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Servicio iniciado'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _finalizarServicio(BuildContext context) async {
    try {
      await BookingRepository().updateStatus(booking.id, BookingStatus.completada);
      await PetRepository().updateStatus(booking.petId, 'disponible');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Servicio finalizado y mascota liberada'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al finalizar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PetModel>>(
      future: _getPet(booking.petId),
      builder: (ctx, petSnap) {
        final petName = petSnap.data?.isNotEmpty == true
            ? petSnap.data!.first.nombre
            : booking.mascotaNombre ?? 'Mascota';
        final petRaza = petSnap.data?.isNotEmpty == true
            ? petSnap.data!.first.raza
            : '';
        final petFoto = petSnap.data?.isNotEmpty == true
            ? petSnap.data!.first.fotoUrl
            : '';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      petFoto.isNotEmpty ? NetworkImage(petFoto) : null,
                  backgroundColor: AppColors.lightBlue,
                  child: petFoto.isEmpty
                      ? const Icon(Icons.pets, color: AppColors.primary)
                      : null,
                ),
                title: Text(petName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (petRaza.isNotEmpty)
                      Text(petRaza,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    Text(
                      '${booking.servicioNombre ?? "Servicio"} • ${DateHelper.formatDate(booking.fechaInicio)}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                trailing: StatusBadge(status: booking.estado),
              ),
              if (booking.estado == BookingStatus.confirmada ||
                  booking.estado == BookingStatus.enCurso) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (booking.estado == BookingStatus.confirmada)
                        ElevatedButton.icon(
                          onPressed: () => _iniciarServicio(context),
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('Iniciar Servicio'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      if (booking.estado == BookingStatus.enCurso)
                        ElevatedButton.icon(
                          onPressed: () => _finalizarServicio(context),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Finalizar Servicio'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<List<PetModel>> _getPet(String petId) async {
    try {
      final snap = await PetRepository()
          .getAllPets()
          .first;
      return snap.where((p) => p.id == petId).toList();
    } catch (_) {
      return [];
    }
  }
}
