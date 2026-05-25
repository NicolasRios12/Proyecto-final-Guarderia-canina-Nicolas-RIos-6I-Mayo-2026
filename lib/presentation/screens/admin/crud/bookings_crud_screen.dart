import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/booking_status.dart';
import '../../../../core/models/booking_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/repositories/booking_repository.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/status_badge.dart';

/// CRUD de reservas para el administrador.
class BookingsCrudScreen extends StatefulWidget {
  const BookingsCrudScreen({super.key});

  @override
  State<BookingsCrudScreen> createState() => _BookingsCrudScreenState();
}

class _BookingsCrudScreenState extends State<BookingsCrudScreen> {
  String _searchQuery = '';

  List<BookingModel> _filterBookings(List<BookingModel> bookings) {
    if (_searchQuery.isEmpty) return bookings;
    final q = _searchQuery.toLowerCase();
    return bookings.where((b) =>
        (b.mascotaNombre?.toLowerCase().contains(q) ?? false) ||
        (b.servicioNombre?.toLowerCase().contains(q) ?? false) ||
        b.estado.label.toLowerCase().contains(q)).toList();
  }

  Future<void> _editBookingStatus(BookingModel booking) async {
    BookingStatus selectedStatus = booking.estado;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cambiar Estado'),
        content: StatefulBuilder(
          builder: (ctx, setDialogState) => DropdownButtonFormField<BookingStatus>(
            value: selectedStatus,
            decoration: const InputDecoration(labelText: 'Estado'),
            items: BookingStatus.values.map((s) =>
              DropdownMenuItem(value: s, child: Text(s.label))
            ).toList(),
            onChanged: (v) { if (v != null) setDialogState(() => selectedStatus = v); },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await BookingRepository().updateStatus(booking.id, selectedStatus);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Estado actualizado'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BookingModel booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta reserva?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await BookingRepository().deleteBooking(booking.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reserva eliminada')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar por mascota, servicio o estado...',
                prefixIcon: const Icon(Icons.search),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<BookingModel>>(
        stream: BookingRepository().getAllBookings(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const LoadingShimmer();
          if (snap.hasError) return const EmptyState(message: 'Error al cargar', icon: Icons.error_outline);
          if (!snap.hasData || snap.data!.isEmpty) return const EmptyState(message: 'Sin reservas');

          final filtered = _filterBookings(snap.data!);
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final b = filtered[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const Icon(Icons.calendar_today, color: AppColors.primary),
                  title: Text(b.mascotaNombre ?? 'Mascota', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.servicioNombre ?? 'Servicio', style: const TextStyle(fontSize: 13)),
                      Text(DateHelper.formatDateTime(b.fechaInicio),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text('\$${b.precioFinal.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusBadge(status: b.estado),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _editBookingStatus(b),
                            child: const Icon(Icons.edit, size: 18, color: AppColors.secondary),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _confirmDelete(b),
                            child: const Icon(Icons.delete, size: 18, color: AppColors.error),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
