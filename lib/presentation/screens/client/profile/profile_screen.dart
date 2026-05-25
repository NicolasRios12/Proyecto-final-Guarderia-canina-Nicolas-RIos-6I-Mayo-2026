import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/pet_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/repositories/pet_repository.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/outlined_button.dart';

/// Pantalla de perfil del cliente con foto, info y lista de mascotas.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(
          body: Center(child: Text('No se encontró el perfil')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          // Foto de perfil
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: user.fotoUrl.isNotEmpty
                            ? NetworkImage(user.fotoUrl)
                            : null,
                        backgroundColor: AppColors.lightBlue,
                        child: user.fotoUrl.isEmpty
                            ? Text(user.nombre[0].toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 40,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold))
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.edit,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(user.nombreCompleto,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                      'Miembro desde ${DateHelper.formatYear(user.fechaRegistro)}',
                      style:
                          const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: AppOutlinedButton(
                      label: 'Editar Perfil',
                      onPressed: () => context.push('/home/edit-profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Divider
          const SliverToBoxAdapter(child: Divider()),
          // Header mascotas
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('Mis Mascotas',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.primary),
                    onPressed: () => context.push('/home/add-pet'),
                  ),
                ],
              ),
            ),
          ),
          // Lista de mascotas
          SliverToBoxAdapter(
            child: StreamBuilder<List<PetModel>>(
              stream: PetRepository().getUserPets(user.uid),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const LoadingShimmer(itemCount: 2);
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snap.data!.length,
                  itemBuilder: (_, i) {
                    final pet = snap.data![i];
                    return _PetTile(pet: pet);
                  },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

/// Tile de mascota con foto, nombre, raza, edad y badge de estado.
class _PetTile extends StatelessWidget {
  final PetModel pet;

  const _PetTile({required this.pet});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage:
            pet.fotoUrl.isNotEmpty ? NetworkImage(pet.fotoUrl) : null,
        backgroundColor: AppColors.lightBlue,
        child: pet.fotoUrl.isEmpty
            ? const Icon(Icons.pets, color: AppColors.primary)
            : null,
      ),
      title: Text(pet.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${pet.raza} • ${pet.edadTexto}',
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 13)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }
}
