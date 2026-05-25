import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/enums/pet_size.dart';
import '../../../../../core/models/pet_model.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pet_provider.dart';
import '../../../../widgets/primary_button.dart';

/// Pantalla para agregar una nueva mascota.
class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _razaCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  final _pesoCtrl = TextEditingController();
  final _notasCtrl = TextEditingController();

  String _selectedSexo = 'macho';
  PetSize _selectedTamanio = PetSize.mediano;
  String _fotoUrl = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _razaCtrl.dispose();
    _edadCtrl.dispose();
    _pesoCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final controller = TextEditingController(text: _fotoUrl);
    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ingresar URL de la foto de la mascota'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://ejemplo.com/foto-mascota.jpg',
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

    if (url != null) {
      setState(() => _fotoUrl = url);
    }
  }

  Future<void> _guardarMascota() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final petId = const Uuid().v4();

      final pet = PetModel(
        id: petId,
        ownerUid: auth.currentUser!.uid,
        nombre: _nombreCtrl.text.trim(),
        raza: _razaCtrl.text.trim(),
        tamanio: _selectedTamanio,
        edadTexto: _edadCtrl.text.trim(),
        sexo: _selectedSexo,
        pesoKg: double.tryParse(_pesoCtrl.text.trim()) ?? 0.0,
        fotoUrl: _fotoUrl,
        notasMedicas: _notasCtrl.text.trim(),
        estado: 'disponible',
        createdAt: DateTime.now(),
      );

      await context.read<PetProvider>().addPet(pet);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Mascota agregada exitosamente!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar mascota: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mascota'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _fotoUrl.isNotEmpty ? NetworkImage(_fotoUrl) : null,
                  backgroundColor: AppColors.lightBlue,
                  child: _fotoUrl.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 32, color: AppColors.primary)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Toca para agregar foto',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 24),

              // Nombre
              TextFormField(
                controller: _nombreCtrl,
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    Validators.required(v, 'Nombre de tu mascota'),
                decoration: const InputDecoration(
                  labelText: 'Nombre de tu mascota',
                  prefixIcon: Icon(Icons.pets),
                ),
              ),
              const SizedBox(height: 16),

              // Raza
              TextFormField(
                controller: _razaCtrl,
                textCapitalization: TextCapitalization.words,
                validator: (v) => Validators.required(v, 'Raza'),
                decoration: const InputDecoration(
                  labelText: 'Raza',
                  prefixIcon: Icon(Icons.category),
                ),
              ),
              const SizedBox(height: 16),

              // Edad
              TextFormField(
                controller: _edadCtrl,
                validator: (v) => Validators.required(v, 'Edad'),
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  hintText: 'Ej: 2 años, 6 meses',
                  prefixIcon: Icon(Icons.cake),
                ),
              ),
              const SizedBox(height: 16),

              // Sexo
              DropdownButtonFormField<String>(
                value: _selectedSexo,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  prefixIcon: Icon(Icons.wc),
                ),
                items: const [
                  DropdownMenuItem(value: 'macho', child: Text('Macho')),
                  DropdownMenuItem(value: 'hembra', child: Text('Hembra')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _selectedSexo = v);
                },
              ),
              const SizedBox(height: 16),

              // Peso
              TextFormField(
                controller: _pesoCtrl,
                keyboardType: TextInputType.number,
                validator: Validators.weight,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
              ),
              const SizedBox(height: 16),

              // Tamaño
              DropdownButtonFormField<PetSize>(
                value: _selectedTamanio,
                decoration: const InputDecoration(
                  labelText: 'Tamaño',
                  prefixIcon: Icon(Icons.straighten),
                ),
                items: PetSize.values
                    .map((s) =>
                        DropdownMenuItem(value: s, child: Text(s.label)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTamanio = v);
                },
              ),
              const SizedBox(height: 16),

              // Notas médicas
              TextFormField(
                controller: _notasCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas médicas (opcional)',
                  hintText: 'Alergias, medicamentos, etc.',
                  prefixIcon: Icon(Icons.medical_information),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),

              // Botón guardar
              PrimaryButton(
                label: 'Guardar Mascota',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _guardarMascota,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
