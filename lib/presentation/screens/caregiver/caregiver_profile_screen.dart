import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/user_repository.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';

/// Pantalla de perfil del cuidador donde puede editar su bio y foto.
class CaregiverProfileScreen extends StatefulWidget {
  const CaregiverProfileScreen({super.key});

  @override
  State<CaregiverProfileScreen> createState() =>
      _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState extends State<CaregiverProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _direccionCtrl;
  late TextEditingController _backgroundImgCtrl;
  late TextEditingController _bioCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser!;
    _nombreCtrl = TextEditingController(text: user.nombre);
    _apellidoCtrl = TextEditingController(text: user.apellido);
    _telefonoCtrl = TextEditingController(text: user.telefono);
    _direccionCtrl = TextEditingController(text: user.direccion);
    _backgroundImgCtrl = TextEditingController(text: user.backgroundImg);
    _bioCtrl = TextEditingController(text: user.bio);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _telefonoCtrl.dispose();
    _direccionCtrl.dispose();
    _backgroundImgCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarPerfil() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final updatedUser = auth.currentUser!.copyWith(
        nombre: _nombreCtrl.text.trim(),
        apellido: _apellidoCtrl.text.trim(),
        telefono: _telefonoCtrl.text.trim(),
        direccion: _direccionCtrl.text.trim(),
        backgroundImg: _backgroundImgCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
      );

      await UserRepository().updateUser(updatedUser);
      auth.updateCurrentUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cambiarFoto() async {
    try {
      final auth = context.read<AuthProvider>();
      final controller = TextEditingController(text: auth.currentUser!.fotoUrl);
      final url = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ingresar URL de foto de perfil'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://ejemplo.com/foto-perfil.jpg',
              labelText: 'URL de la imagen',
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Guardar'),
            ),
          ],
        ),
      );

      if (url == null) return;

      setState(() => _isLoading = true);
      final updatedUser = auth.currentUser!.copyWith(fotoUrl: url);
      await UserRepository().updateUser(updatedUser);
      auth.updateCurrentUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto actualizada exitosamente'),
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Vista previa de cabecera con Portada y Foto de perfil
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Imagen de portada
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      image: user.backgroundImg.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(user.backgroundImg),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: user.backgroundImg.isEmpty
                        ? Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Opacity(
                                opacity: 0.15,
                                child: Icon(Icons.pets, size: 80, color: Colors.white),
                              ),
                            ),
                          )
                        : null,
                  ),
                  // Etiqueta indicadora
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.image, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Portada de fondo',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Foto de perfil superpuesta
                  Positioned(
                    bottom: -40,
                    child: GestureDetector(
                      onTap: _cambiarFoto,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: user.fotoUrl.isNotEmpty
                              ? NetworkImage(user.fotoUrl)
                              : null,
                          backgroundColor: AppColors.lightBlue,
                          child: user.fotoUrl.isEmpty
                              ? const Icon(Icons.camera_alt, size: 30, color: AppColors.primary)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 56), // Espacio para el avatar superpuesto
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nombreCtrl,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => Validators.required(v, 'Nombre'),
                      decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person_outline)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _apellidoCtrl,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => Validators.required(v, 'Apellido'),
                      decoration: const InputDecoration(labelText: 'Apellido', prefixIcon: Icon(Icons.person_outline)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone_outlined)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _direccionCtrl,
                      decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on_outlined)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _backgroundImgCtrl,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'URL de Imagen de Fondo (Portada)',
                        hintText: 'https://ejemplo.com/mi-portada.jpg',
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Biografía / Descripción',
                        hintText: 'Cuéntale a los clientes sobre ti y tu experiencia',
                        prefixIcon: Icon(Icons.info_outline),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: 'Guardar Cambios',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _guardarPerfil,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
