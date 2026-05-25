import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/booking_status.dart';
import '../../../../core/models/booking_model.dart';
import '../../../../core/models/review_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/repositories/booking_repository.dart';
import '../../../../data/repositories/review_repository.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/status_badge.dart';

/// Pantalla para que el cliente gestione y visualice sus reservas.
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final ReviewRepository _reviewRepo = ReviewRepository();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Inicia sesión para ver tus reservas')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingRepository().getClientBookings(user.uid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer(itemCount: 3);
          }
          if (snap.hasError) {
            return const EmptyState(
              message: 'Error al cargar reservas',
              icon: Icons.error_outline,
            );
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const EmptyState(
              message: 'No tienes reservas aún',
              subtitle: 'Reserva paseos o guardería para ver tus servicios aquí',
              icon: Icons.calendar_today_outlined,
            );
          }

          return ListView.builder(
            itemCount: snap.data!.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (_, i) {
              final booking = snap.data![i];
              return _ClientBookingCard(
                booking: booking,
                reviewRepo: _reviewRepo,
                clientNombre: user.nombreCompleto,
                onReviewed: () {
                  setState(() {}); // Forzar refresco de los FutureBuilders
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Card individual de reserva para clientes con lógica de reseña.
class _ClientBookingCard extends StatelessWidget {
  final BookingModel booking;
  final ReviewRepository reviewRepo;
  final String clientNombre;
  final VoidCallback onReviewed;

  const _ClientBookingCard({
    required this.booking,
    required this.reviewRepo,
    required this.clientNombre,
    required this.onReviewed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: Mascota y Servicio + Estado
            Row(
              children: [
                const Icon(Icons.pets, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.mascotaNombre ?? 'Mascota',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        booking.servicioNombre ?? 'Servicio',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: booking.estado),
              ],
            ),
            const Divider(height: 20),
            // Fecha y precio final
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  DateHelper.formatDateTime(booking.fechaInicio),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${booking.precioFinal.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (booking.notas.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notas: ${booking.notas}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            // Botón/Badge para Calificar
            if (booking.estado == BookingStatus.completada) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              FutureBuilder<bool>(
                future: reviewRepo.hasReview(booking.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  }
                  final hasReviewed = snapshot.data ?? false;

                  if (hasReviewed) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.completadaBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: AppColors.completadaText, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Servicio Calificado',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.completadaText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showReviewDialog(context),
                        icon: const Icon(Icons.star, size: 16),
                        label: const Text('Calificar Servicio'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Diálogo modal interactivo para ingresar estrellas y comentarios.
  Future<void> _showReviewDialog(BuildContext context) async {
    double selectedRating = 5.0;
    final commentController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.star_rate_rounded, color: Colors.amber, size: 28),
                  SizedBox(width: 8),
                  Text('Calificar Servicio',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '¿Cómo calificarías el servicio prestado para tu mascota en esta reserva?',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Selector de estrellas táctil/interactivo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isSelected = starIndex <= selectedRating;
                        return IconButton(
                          onPressed: () {
                            setDialogState(() {
                              selectedRating = starIndex.toDouble();
                            });
                          },
                          icon: Icon(
                            isSelected ? Icons.star : Icons.star_border,
                            color: isSelected ? Colors.amber : Colors.grey,
                            size: 36,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Puntuación: ${selectedRating.toStringAsFixed(0)} / 5',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText: 'Cuéntanos tu experiencia (opcional)...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancelar',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Crear reseña
                    final review = ReviewModel(
                      id: booking.id, // Booking ID as review ID!
                      caregiverUid: booking.caregiverUid,
                      clientUid: booking.clientUid,
                      clientNombre: clientNombre,
                      rating: selectedRating,
                      comentario: commentController.text.trim(),
                      fecha: DateTime.now(),
                    );

                    Navigator.pop(dialogCtx);

                    try {
                      await reviewRepo.createReview(review);
                      onReviewed(); // Notificar para refrescar UI
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ ¡Gracias por tu reseña!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al enviar reseña: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
