import 'package:intl/intl.dart';

/// Helpers para formateo de fechas en español.
class DateHelper {
  DateHelper._();

  /// Formato: dd/MM/yyyy
  static String formatDate(DateTime dt) =>
    DateFormat('dd/MM/yyyy').format(dt);

  /// Formato: dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dt) =>
    DateFormat('dd/MM/yyyy HH:mm').format(dt);

  /// Formato: HH:mm
  static String formatTime(DateTime dt) =>
    DateFormat('HH:mm').format(dt);

  /// Formato: yyyy
  static String formatYear(DateTime dt) =>
    DateFormat('yyyy').format(dt);

  /// Formato relativo en español: "Ahora", "hace 5 min", "Ayer", etc.
  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return DateFormat('HH:mm').format(dt);
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'hace ${diff.inDays} días';
    return DateFormat('dd/MM').format(dt);
  }
}
