import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/constants/app_colors.dart';

/// Widget de estrellas de rating con puntuación numérica y count opcional.
class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      RatingBarIndicator(
        rating: rating,
        itemBuilder: (_, __) =>
            const Icon(Icons.star, color: AppColors.warning),
        itemCount: 5,
        itemSize: size,
      ),
      const SizedBox(width: 4),
      Text(
        rating.toStringAsFixed(1),
        style: TextStyle(
            fontSize: size * 0.875,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
      ),
      if (reviewCount != null)
        Text(
          ' ($reviewCount)',
          style: TextStyle(
              fontSize: size * 0.875, color: AppColors.textSecondary),
        ),
    ],
  );
}
