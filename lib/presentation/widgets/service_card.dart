import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/user_model.dart';
import 'rating_stars.dart';

/// Card que muestra un cuidador en la lista de servicios.
/// Incluye avatar, información, precio, rating y botón de reservar.
class ServiceCard extends StatelessWidget {
  final UserModel caregiver;
  final double rating;
  final int reviewCount;
  final double precio;
  final String unidadPrecio;
  final List<String> ofrece;
  final VoidCallback onReservar;

  const ServiceCard({
    super.key,
    required this.caregiver,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.precio = 0,
    this.unidadPrecio = 'día',
    this.ofrece = const [],
    required this.onReservar,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila superior: avatar + info + precio
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar circular 56px
              CircleAvatar(
                radius: 28,
                backgroundImage: caregiver.fotoUrl.isNotEmpty
                    ? NetworkImage(caregiver.fotoUrl)
                    : null,
                backgroundColor: AppColors.lightBlue,
                child: caregiver.fotoUrl.isEmpty
                    ? Text(
                        caregiver.nombre.isNotEmpty
                            ? caregiver.nombre[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20))
                    : null,
              ),
              const SizedBox(width: 12),
              // Nombre + ubicación + ofrece
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(caregiver.nombreCompleto,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text('Juárez, Chih',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    ...ofrece.take(3).map((item) => Text(
                          '- $item',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        )),
                  ],
                ),
              ),
              // Precio alineado derecha
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${precio.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary)),
                  Text('/$unidadPrecio',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Fila inferior: rating + botón
          Row(
            children: [
              RatingStars(rating: rating, reviewCount: reviewCount),
              const Spacer(),
              ElevatedButton(
                onPressed: onReservar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                ),
                child: const Text('Reservar'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
