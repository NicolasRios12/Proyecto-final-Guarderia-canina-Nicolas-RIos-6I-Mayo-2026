import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mock_data.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/repositories/chat_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/repositories/review_repository.dart';
import '../../../../core/models/review_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/outlined_button.dart';
import '../../../widgets/rating_stars.dart';

/// Pantalla de perfil de un cuidador (vista del cliente).
/// Muestra información, servicios, tarifas y botones de acción.
class CaregiverProfileScreen extends StatelessWidget {
  final String caregiverUid;

  const CaregiverProfileScreen({super.key, required this.caregiverUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Cuidador'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<UserModel?>(
        future: UserRepository().getUser(caregiverUid),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || !snap.hasData || snap.data == null) {
            return const Center(
                child: Text('No se encontró el perfil del cuidador'));
          }

          final caregiver = snap.data!;
          return StreamBuilder<List<ReviewModel>>(
            stream: ReviewRepository().getCaregiverReviews(caregiverUid),
            builder: (context, reviewSnap) {
              final reviews = reviewSnap.data ?? [];

              final double avgRating = reviews.isNotEmpty
                  ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length
                  : 4.8;
              final int reviewCount = reviews.isNotEmpty
                  ? reviews.length
                  : 23;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero image / avatar grande
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: AppColors.lightBlue,
                      child: caregiver.fotoUrl.isNotEmpty
                          ? Image.network(caregiver.fotoUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(caregiver))
                          : _buildAvatarPlaceholder(caregiver),
                    ),
                    // Sección "¿Quién cuida?"
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: caregiver.fotoUrl.isNotEmpty
                                    ? NetworkImage(caregiver.fotoUrl)
                                    : null,
                                backgroundColor: AppColors.lightBlue,
                                child: caregiver.fotoUrl.isEmpty
                                    ? Text(caregiver.nombre[0].toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 28,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold))
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(caregiver.nombreCompleto,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        'Miembro desde ${DateHelper.formatYear(caregiver.fechaRegistro)}',
                                        style: const TextStyle(
                                            color: AppColors.textSecondary)),
                                    const SizedBox(height: 4),
                                    RatingStars(
                                        rating: avgRating, reviewCount: reviewCount),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (caregiver.bio.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(caregiver.bio,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14)),
                          ],
                          const SizedBox(height: 24),
                          // Sección servicios y tarifas
                          const Text('SERVICIOS Y TARIFAS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  letterSpacing: 1)),
                          const SizedBox(height: 12),
                          _ServiceTile(
                              icon: Icons.hotel,
                              nombre: 'Hospedaje en Casa',
                              precio: 'Desde \$240'),
                          _ServiceTile(
                              icon: Icons.groups,
                              nombre: 'Guardería Diurna',
                              precio: 'Desde \$180'),
                          _ServiceTile(
                              icon: Icons.directions_walk,
                              nombre: 'Paseo Individual',
                              precio: 'Desde \$120'),
                          const SizedBox(height: 16),
                          // Lo que ofrece
                          const Text('Lo que ofrece',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          const _BulletPoint(text: 'Casa con jardín amplio'),
                          const _BulletPoint(
                              text: 'Fotos y actualizaciones diarias'),
                          const _BulletPoint(
                              text: 'Paseos incluidos en hospedaje'),
                          const SizedBox(height: 24),
                          // Reseñas
                          const Text('Reseñas',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          if (reviews.isEmpty)
                            ...MockData.mockReviews.map((r) => _ReviewTile(
                                  nombre: r['nombre'] as String,
                                  rating: (r['rating'] as num).toDouble(),
                                  comentario: r['comentario'] as String,
                                  fecha: r['fecha'] as String,
                                ))
                          else
                            ...reviews.map((r) => _ReviewTile(
                                  nombre: r.clientNombre,
                                  rating: r.rating,
                                  comentario: r.comentario,
                                  fecha: DateHelper.formatRelative(r.fecha),
                                )),
                          const SizedBox(height: 24),
                          // Botones de acción
                          PrimaryButton(
                            label: 'Reservar ahora',
                            onPressed: () => context.push('/home/booking',
                                extra: {'caregiverUid': caregiverUid}),
                          ),
                          const SizedBox(height: 12),
                          AppOutlinedButton(
                            label: 'Contactar',
                            icon: Icons.chat_bubble_outline,
                            onPressed: () => _openChat(context, caregiver),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAvatarPlaceholder(UserModel caregiver) {
    return Center(
      child: Icon(Icons.person,
          size: 80, color: AppColors.primary.withValues(alpha: 0.5)),
    );
  }

  /// Abre o crea un chat con el cuidador.
  Future<void> _openChat(BuildContext context, UserModel caregiver) async {
    try {
      final auth = context.read<AuthProvider>();
      final chatId = await ChatRepository().getOrCreateChat(
        uid1: auth.currentUser!.uid,
        uid2: caregiver.uid,
      );
      if (context.mounted) {
        context.push('/home/chat/$chatId?otherUid=${caregiver.uid}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al abrir chat: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

/// Tile de servicio con ícono, nombre y precio.
class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String nombre;
  final String precio;

  const _ServiceTile({
    required this.icon,
    required this.nombre,
    required this.precio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(nombre, style: const TextStyle(fontSize: 14))),
          Text(precio,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}

/// Punto de viñeta simple.
class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 14))),
        ],
      ),
    );
  }
}

/// Tile de reseña de un cliente.
class _ReviewTile extends StatelessWidget {
  final String nombre;
  final double rating;
  final String comentario;
  final String fecha;

  const _ReviewTile({
    required this.nombre,
    required this.rating,
    required this.comentario,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(fecha,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            RatingStars(rating: rating, size: 14),
            const SizedBox(height: 4),
            Text(comentario,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
