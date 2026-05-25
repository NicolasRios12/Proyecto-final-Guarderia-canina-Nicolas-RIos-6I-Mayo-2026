import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

/// Panel de administración con grid de accesos a CRUD de cada tabla.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 1.1,
        children: [
          _AdminCard(
            icon: Icons.people,
            title: 'Usuarios',
            subtitle: 'Gestionar cuentas',
            color: AppColors.primary,
            onTap: () => context.push('/admin/users'),
          ),
          _AdminCard(
            icon: Icons.pets,
            title: 'Mascotas',
            subtitle: 'Ver mascotas',
            color: AppColors.success,
            onTap: () => context.push('/admin/pets'),
          ),
          _AdminCard(
            icon: Icons.miscellaneous_services,
            title: 'Servicios',
            subtitle: 'Configurar servicios',
            color: AppColors.warning,
            onTap: () => context.push('/admin/services'),
          ),
          _AdminCard(
            icon: Icons.calendar_today,
            title: 'Reservas',
            subtitle: 'Ver todas las reservas',
            color: AppColors.secondary,
            onTap: () => context.push('/admin/bookings'),
          ),
        ],
      ),
    );
  }
}

/// Card del dashboard admin con ícono, título y subtítulo.
class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
