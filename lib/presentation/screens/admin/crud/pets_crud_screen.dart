import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/pet_model.dart';
import '../../../../data/repositories/pet_repository.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';

/// CRUD de mascotas para el administrador.
class PetsCrudScreen extends StatefulWidget {
  const PetsCrudScreen({super.key});

  @override
  State<PetsCrudScreen> createState() => _PetsCrudScreenState();
}

class _PetsCrudScreenState extends State<PetsCrudScreen> {
  String _searchQuery = '';

  List<PetModel> _filterPets(List<PetModel> pets) {
    if (_searchQuery.isEmpty) return pets;
    final q = _searchQuery.toLowerCase();
    return pets.where((p) =>
        p.nombre.toLowerCase().contains(q) ||
        p.raza.toLowerCase().contains(q)).toList();
  }

  Future<void> _editPet(PetModel pet) async {
    final nombreCtrl = TextEditingController(text: pet.nombre);
    final razaCtrl = TextEditingController(text: pet.raza);
    final edadCtrl = TextEditingController(text: pet.edadTexto);
    final notasCtrl = TextEditingController(text: pet.notasMedicas);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Mascota'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              const SizedBox(height: 8),
              TextField(controller: razaCtrl, decoration: const InputDecoration(labelText: 'Raza')),
              const SizedBox(height: 8),
              TextField(controller: edadCtrl, decoration: const InputDecoration(labelText: 'Edad')),
              const SizedBox(height: 8),
              TextField(controller: notasCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Notas médicas')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final updated = pet.copyWith(
                nombre: nombreCtrl.text.trim(),
                raza: razaCtrl.text.trim(),
                edadTexto: edadCtrl.text.trim(),
                notasMedicas: notasCtrl.text.trim(),
              );
              await PetRepository().updatePet(updated);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mascota actualizada'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    nombreCtrl.dispose();
    razaCtrl.dispose();
    edadCtrl.dispose();
    notasCtrl.dispose();
  }

  Future<void> _confirmDelete(PetModel pet) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta mascota? Esta acción no se puede deshacer.'),
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
      final deleted = await PetRepository().deletePet(pet.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(deleted ? 'Mascota eliminada' : 'No se puede eliminar: tiene reservas activas'),
            backgroundColor: deleted ? AppColors.success : AppColors.warning,
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
        title: const Text('Mascotas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o raza...',
                prefixIcon: const Icon(Icons.search),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<PetModel>>(
        stream: PetRepository().getAllPets(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const LoadingShimmer();
          if (snap.hasError) return const EmptyState(message: 'Error al cargar', icon: Icons.error_outline);
          if (!snap.hasData || snap.data!.isEmpty) return const EmptyState(message: 'Sin mascotas');

          final filtered = _filterPets(snap.data!);
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final pet = filtered[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: pet.fotoUrl.isNotEmpty ? NetworkImage(pet.fotoUrl) : null,
                    backgroundColor: AppColors.lightBlue,
                    child: pet.fotoUrl.isEmpty ? const Icon(Icons.pets, color: AppColors.primary) : null,
                  ),
                  title: Text(pet.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${pet.raza} • ${pet.tamanio.label} • ${pet.edadTexto}',
                      style: const TextStyle(fontSize: 13)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editPet(pet)),
                      IconButton(icon: const Icon(Icons.delete, color: AppColors.error, size: 20), onPressed: () => _confirmDelete(pet)),
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
