import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mock_data.dart';
import '../../../../core/enums/service_type.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';
import '../../../widgets/service_card.dart';

/// Pantalla de lista de cuidadores filtrada por categoría de servicio.
class ServiceListScreen extends StatelessWidget {
  final String categoria;

  const ServiceListScreen({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    final serviceType = ServiceType.fromString(categoria);

    return Scaffold(
      appBar: AppBar(
        title: Text('${serviceType.emoji} ${serviceType.label}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Cuidadores Populares',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: UserRepository().getCaregivers(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const LoadingShimmer();
                }
                if (snap.hasError) {
                  return const EmptyState(
                      message: 'Error al cargar cuidadores',
                      icon: Icons.error_outline);
                }

                // Si hay cuidadores en Firestore, mostrarlos
                if (snap.hasData && snap.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snap.data!.length,
                    itemBuilder: (_, i) {
                      final caregiver = snap.data![i];
                      return ServiceCard(
                        caregiver: caregiver,
                        rating: 4.5 + (i * 0.2 % 0.5),
                        reviewCount: 10 + i * 7,
                        precio: _precioParaCategoria(categoria),
                        unidadPrecio: _unidadParaCategoria(categoria),
                        ofrece: _ofrecePorCategoria(categoria),
                        onReservar: () =>
                            context.push('/home/caregiver/${caregiver.uid}'),
                      );
                    },
                  );
                }

                // Fallback: mostrar datos mock si no hay cuidadores
                return ListView.builder(
                  itemCount: MockData.caregivers.length,
                  itemBuilder: (_, i) {
                    final mock = MockData.caregivers[i];
                    final mockUser = UserModel(
                      uid: 'mock_$i',
                      email: '',
                      nombre: mock['nombre'] as String,
                      apellido: mock['apellido'] as String,
                      telefono: '',
                      direccion: '',
                      rol: UserRole.cuidador,
                      fotoUrl: mock['foto_url'] as String,
                      backgroundImg: '',
                      bio: '',
                      fechaRegistro: DateTime.now(),
                      activo: true,
                    );
                    return ServiceCard(
                      caregiver: mockUser,
                      rating: (mock['rating'] as num).toDouble(),
                      reviewCount: mock['reviews'] as int,
                      precio: (mock['precio'] as num).toDouble(),
                      unidadPrecio: mock['unidad'] as String,
                      ofrece: List<String>.from(mock['ofrece'] as List),
                      onReservar: () =>
                          context.push('/home/caregiver/${mockUser.uid}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _precioParaCategoria(String cat) {
    switch (cat) {
      case 'hospedaje': return 240;
      case 'guarderia': return 180;
      case 'paseo': return 120;
      default: return 180;
    }
  }

  String _unidadParaCategoria(String cat) {
    switch (cat) {
      case 'hospedaje': return 'noche';
      case 'guarderia': return 'día';
      case 'paseo': return 'hora';
      default: return 'día';
    }
  }

  List<String> _ofrecePorCategoria(String cat) {
    switch (cat) {
      case 'hospedaje': return ['Casa con jardín', 'Fotos diarias', 'Paseos incluidos'];
      case 'guarderia': return ['Sin otras mascotas', 'Actualizaciones en tiempo real', 'Actividades'];
      case 'paseo': return ['Rutas seguras', 'GPS tracking', 'Entrenamiento básico'];
      default: return [];
    }
  }
}
