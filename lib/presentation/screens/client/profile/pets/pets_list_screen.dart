import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/models/pet_model.dart';
import '../../../../../data/repositories/pet_repository.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/loading_shimmer.dart';

/// Pantalla de lista de mascotas del usuario.
class PetsListScreen extends StatelessWidget {
  const PetsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/home/add-pet'),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<PetModel>>(
        stream: PetRepository().getUserPets(auth.currentUser!.uid),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snap.hasError) {
            return const EmptyState(
                message: 'Error al cargar mascotas',
                icon: Icons.error_outline);
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return EmptyState(
              message: 'Sin mascotas registradas',
              subtitle: 'Agrega tu primera mascota',
              icon: Icons.pets,
              ctaLabel: 'Agregar Mascota',
              onCta: () => context.push('/home/add-pet'),
            );
          }

          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final pet = snap.data![i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: pet.fotoUrl.isNotEmpty
                        ? NetworkImage(pet.fotoUrl)
                        : null,
                    backgroundColor: AppColors.lightBlue,
                    child: pet.fotoUrl.isEmpty
                        ? const Icon(Icons.pets, color: AppColors.primary)
                        : null,
                  ),
                  title: Text(pet.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${pet.raza} • ${pet.edadTexto} • ${pet.tamanio.label}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: pet.estado == 'disponible'
                          ? AppColors.completadaBg
                          : AppColors.pendienteBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      pet.estado == 'disponible' ? 'Disponible' : 'En servicio',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: pet.estado == 'disponible'
                            ? AppColors.completadaText
                            : AppColors.pendienteText,
                      ),
                    ),
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
