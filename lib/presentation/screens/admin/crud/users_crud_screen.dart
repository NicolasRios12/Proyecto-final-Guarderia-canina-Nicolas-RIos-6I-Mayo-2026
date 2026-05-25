import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';

/// CRUD de usuarios para el administrador.
class UsersCrudScreen extends StatefulWidget {
  const UsersCrudScreen({super.key});

  @override
  State<UsersCrudScreen> createState() => _UsersCrudScreenState();
}

class _UsersCrudScreenState extends State<UsersCrudScreen> {
  String _searchQuery = '';

  List<UserModel> _filterUsers(List<UserModel> users) {
    if (_searchQuery.isEmpty) return users;
    final q = _searchQuery.toLowerCase();
    return users.where((u) =>
        u.nombreCompleto.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q) ||
        u.rol.name.toLowerCase().contains(q)).toList();
  }

  Future<void> _editUser(UserModel user) async {
    final rolCtrl = TextEditingController(text: user.rol.name);
    final nombreCtrl = TextEditingController(text: user.nombre);
    final apellidoCtrl = TextEditingController(text: user.apellido);
    final telefonoCtrl = TextEditingController(text: user.telefono);
    UserRole selectedRole = user.rol;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Usuario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              const SizedBox(height: 8),
              TextField(controller: apellidoCtrl, decoration: const InputDecoration(labelText: 'Apellido')),
              const SizedBox(height: 8),
              TextField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: 'Teléfono')),
              const SizedBox(height: 8),
              StatefulBuilder(
                builder: (ctx, setDialogState) => DropdownButtonFormField<UserRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name))).toList(),
                  onChanged: (v) { if (v != null) setDialogState(() => selectedRole = v); },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final updated = user.copyWith(
                nombre: nombreCtrl.text.trim(),
                apellido: apellidoCtrl.text.trim(),
                telefono: telefonoCtrl.text.trim(),
                rol: selectedRole,
              );
              await UserRepository().updateUser(updated);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuario actualizado'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    rolCtrl.dispose();
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    telefonoCtrl.dispose();
  }

  Future<void> _confirmDelete(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar este registro? Esta acción no se puede deshacer.'),
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
      await UserRepository().deleteUser(user.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario eliminado')),
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
        title: const Text('Usuarios'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, email o rol...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: UserRepository().getAllUsers(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const LoadingShimmer();
          if (snap.hasError) return const EmptyState(message: 'Error al cargar usuarios', icon: Icons.error_outline);
          if (!snap.hasData || snap.data!.isEmpty) return const EmptyState(message: 'Sin usuarios');

          final filtered = _filterUsers(snap.data!);
          if (filtered.isEmpty) return const EmptyState(message: 'Sin resultados', icon: Icons.search_off);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Rol')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: filtered.map((u) => DataRow(cells: [
                  DataCell(Text(u.nombreCompleto)),
                  DataCell(_RoleBadge(role: u.rol)),
                  DataCell(Text(u.email, style: const TextStyle(fontSize: 13))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _editUser(u)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error, size: 20),
                        onPressed: () => _confirmDelete(u),
                      ),
                    ],
                  )),
                ])).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (role) {
      case UserRole.admin: bg = AppColors.canceladaBg; fg = AppColors.canceladaText;
      case UserRole.cuidador: bg = AppColors.confirmadaBg; fg = AppColors.confirmadaText;
      case UserRole.cliente: bg = AppColors.completadaBg; fg = AppColors.completadaText;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(role.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fg)),
    );
  }
}
