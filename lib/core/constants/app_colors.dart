import 'package:flutter/material.dart';

/// Paleta de colores centralizada de Dog Club.
/// Todos los colores de la app se definen aquí — nunca hardcodear Color(0xFF...)
/// en otros archivos.
class AppColors {
  AppColors._();

  // Colores primarios
  static const Color primary = Color(0xFF1E40AF);
  static const Color secondary = Color(0xFF3B82F6);

  // Superficies y fondos
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);

  // Textos
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textHint = Color(0xFF94A3B8);

  // Estados
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Fondos de badges
  static const Color pendienteBg = Color(0xFFFEF3C7);
  static const Color confirmadaBg = Color(0xFFDBEAFE);
  static const Color enCursoBg = Color(0xFFDDEEFF);
  static const Color completadaBg = Color(0xFFD1FAE5);
  static const Color canceladaBg = Color(0xFFFEE2E2);

  // Textos de badges
  static const Color pendienteText = Color(0xFFB45309);
  static const Color confirmadaText = Color(0xFF1D4ED8);
  static const Color enCursoText = Color(0xFF1E40AF);
  static const Color completadaText = Color(0xFF065F46);
  static const Color canceladaText = Color(0xFFB91C1C);

  // Otros
  static const Color divider = Color(0xFFE2E8F0);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);
  static const Color lightBlue = Color(0xFFEFF6FF);
  static const Color disabled = Color(0xFF94A3B8);
}
