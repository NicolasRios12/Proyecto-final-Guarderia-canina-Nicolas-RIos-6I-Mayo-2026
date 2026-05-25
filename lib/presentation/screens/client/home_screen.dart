import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

/// Pantalla principal del cliente.
/// Muestra banner hero y cards de los 3 tipos de servicio.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar GlobalKey para controlar el Scaffold desde el AppBar
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(activeRoute: '/home'),
      appBar: CustomAppBar(
        showLogo: true,
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner hero azul
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cuidadores de mascotas de confianza cerca de ti',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://raw.githubusercontent.com/NicolasRios12/imagenes-para-flutter-6I-fecha-11-feb-2026/refs/heads/main/imagen_2026-04-15_195640340.png',
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Reserva espacios sin filas y paseos seguros para perros',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Título de sección
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Nuestros Servicios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            // Cards de servicios
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _ServiceTypeCard(
                    icon: Icons.hotel,
                    titulo: 'Hospedaje',
                    subtitulo: 'Ver opciones disponibles',
                    onTap: () =>
                        context.push('/home/services/hospedaje'),
                  ),
                  const SizedBox(height: 8),
                  _ServiceTypeCard(
                    icon: Icons.groups,
                    titulo: 'Guardería',
                    subtitulo: 'Ver opciones disponibles',
                    onTap: () =>
                        context.push('/home/services/guarderia'),
                  ),
                  const SizedBox(height: 8),
                  _ServiceTypeCard(
                    icon: Icons.directions_walk,
                    titulo: 'Paseos',
                    subtitulo: 'Ver opciones disponibles',
                    onTap: () =>
                        context.push('/home/services/paseo'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Card individual de tipo de servicio con ícono, título y chevron.
class _ServiceTypeCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ServiceTypeCard({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitulo,
            style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
        onTap: onTap,
      ),
    );
  }
}
