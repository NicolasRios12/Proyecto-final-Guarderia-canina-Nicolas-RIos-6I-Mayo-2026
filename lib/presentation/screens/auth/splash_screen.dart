import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/user_role.dart';
import '../../providers/auth_provider.dart';

/// Pantalla de splash con logo y verificación de autenticación.
/// Muestra el logo mínimo 2 segundos y redirige según el rol del usuario.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Esperar mínimo 2 segundos para mostrar el logo
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      context.read<AuthProvider>().initialize(),
    ]);

    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.isAuthenticated) {
      switch (auth.role) {
        case UserRole.admin:
          context.go('/admin');
          break;
        case UserRole.cuidador:
          context.go('/caregiver');
          break;
        default:
          context.go('/home');
      }
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text('Dog Club',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Guardería Canina',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
            SizedBox(height: 48),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
