import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/service_model.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';

/// CRUD de servicios para el administrador.
class ServicesCrudScreen extends StatefulWidget {
  const ServicesCrudScreen({super.key});

  @override
  State<ServicesCrudScreen> createState() => _ServicesCrudScreenState();
}

class _ServicesCrudScreenState extends State<ServicesCrudScreen> {
  final _db = FirebaseFirestore.instance;

  Future<void> _editService(ServiceModel service) async {
    final nombreCtrl = TextEditingController(text: service.nombre);
    final descripcionCtrl = TextEditingController(text: service.descripcion);
    final precioCtrl = TextEditingController(text: service.precioBase.toStringAsFixed(0));
    final duracionCtrl = TextEditingController(text: service.duracionMin.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Servicio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              const SizedBox(height: 8),
              TextField(controller: descripcionCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Descripción')),
              const SizedBox(height: 8),
              TextField(controller: precioCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio Base')),
              const SizedBox(height: 8),
              TextField(controller: duracionCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duración (min)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _db.collection('services').doc(service.id).update({
                'nombre': nombreCtrl.text.trim(),
                'descripcion': descripcionCtrl.text.trim(),
                'precio_base': double.tryParse(precioCtrl.text) ?? service.precioBase,
                'duracion_min': int.tryParse(duracionCtrl.text) ?? service.duracionMin,
              });
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Servicio actualizado'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    precioCtrl.dispose();
    duracionCtrl.dispose();
  }

  Future<void> _toggleActivo(ServiceModel service) async {
    try {
      await _db.collection('services').doc(service.id).update({
        'activo': !service.activo,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(service.activo ? 'Servicio desactivado' : 'Servicio activado'),
            backgroundColor: AppColors.success,
          ),
        );
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
        title: const Text('Servicios'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('services').snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const LoadingShimmer();
          if (snap.hasError) return const EmptyState(message: 'Error al cargar', icon: Icons.error_outline);
          if (!snap.hasData || snap.data!.docs.isEmpty) return const EmptyState(message: 'Sin servicios');

          final services = snap.data!.docs
              .map((d) => ServiceModel.fromMap(d.data() as Map<String, dynamic>, d.id))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (_, i) {
              final s = services[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(s.categoria.emoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(s.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                          Switch(
                            value: s.activo,
                            activeColor: AppColors.success,
                            onChanged: (_) => _toggleActivo(s),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(s.descripcion, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Precio: \$${s.precioBase.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(width: 16),
                          Text('Duración: ${s.duracionMin} min',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editService(s)),
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
