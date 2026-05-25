import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'primary_button.dart';

/// Widget para mostrar un estado vacío con ícono, mensaje y CTA opcional.
class EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: AppColors.divider),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary),
              textAlign: TextAlign.center),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!,
                style: const TextStyle(
                    color: AppColors.textHint, fontSize: 14),
                textAlign: TextAlign.center),
          ],
          if (ctaLabel != null && onCta != null) ...[
            const SizedBox(height: 24),
            PrimaryButton(label: ctaLabel!, onPressed: onCta, width: 200),
          ],
        ],
      ),
    ),
  );
}
