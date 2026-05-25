import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

/// Drawer lateral personalizado de Dog Club.
/// Muestra navegación principal, servicios expandibles y opción de cerrar sesión.
class CustomDrawer extends StatelessWidget {
  final String activeRoute;

  const CustomDrawer({super.key, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header azul con logo
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.primary,
              child: Row(
                children: [
                  const Icon(Icons.pets, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Dog Club',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Items de navegación
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'Inicio',
                    isActive: activeRoute == '/home',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/home');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Chats',
                    isActive: activeRoute == '/home/chats',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/home/chats');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.calendar_today_outlined,
                    label: 'Mis Reservas',
                    isActive: activeRoute == '/home/bookings',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/home/bookings');
                    },
                  ),
                  // Servicios expandibles
                  ExpansionTile(
                    leading: const Icon(Icons.pets_outlined),
                    title: const Text('Servicios'),
                    children: [
                      _DrawerItem(
                        icon: Icons.hotel,
                        label: 'Hospedaje',
                        isActive: false,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/home/services/hospedaje');
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.groups,
                        label: 'Guardería',
                        isActive: false,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/home/services/guarderia');
                        },
                      ),
                      _DrawerItem(
                        icon: Icons.directions_walk,
                        label: 'Paseos',
                        isActive: false,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/home/services/paseo');
                        },
                      ),
                    ],
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    label: 'Perfil',
                    isActive: activeRoute == '/home/profile',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/home/profile');
                    },
                  ),
                ],
              ),
            ),
            // Cerrar sesión al fondo
            const Divider(),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Cerrar Sesión',
              isActive: false,
              textColor: AppColors.error,
              iconColor: AppColors.error,
              onTap: () async {
                Navigator.pop(context);
                await auth.logout();
                if (context.mounted) context.go('/login');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Item individual del drawer con indicador de ruta activa.
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon,
        color: iconColor ??
            (isActive ? AppColors.primary : AppColors.textSecondary)),
    title: Text(label,
        style: TextStyle(
            color: textColor ??
                (isActive ? AppColors.primary : AppColors.textPrimary),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
    tileColor: isActive ? AppColors.lightBlue : null,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    onTap: onTap,
  );
}
