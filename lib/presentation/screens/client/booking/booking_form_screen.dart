import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/pet_model.dart';
import '../../../../core/models/service_model.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/booking_provider.dart';
import '../../../providers/pet_provider.dart';
import '../../../widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Formulario de reserva con selección de servicio, fecha, hora y mascota.
class BookingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;

  const BookingFormScreen({super.key, this.extra});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  ServiceModel? _selectedService;
  DateTime? _selectedDate;
  String? _selectedHour;
  PetModel? _selectedPet;
  String? _caregiverUid;
  bool _isLoading = false;

  List<ServiceModel> _services = [];

  final _notasCtrl = TextEditingController();

  final List<String> _horarios = [
    '09:00', '10:00', '11:00', '12:00',
    '14:00', '15:00', '16:00', '17:00',
  ];

  @override
  void initState() {
    super.initState();
    _caregiverUid = widget.extra?['caregiverUid'] as String?;
    _loadServices();
    // Iniciar escucha de mascotas del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUser != null) {
        context.read<PetProvider>().startListening(auth.currentUser!.uid);
      }
    });
  }

  @override
  void dispose() {
    _notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection('services').get();
      setState(() {
        _services = snap.docs
            .map((d) => ServiceModel.fromMap(d.data(), d.id))
            .where((s) => s.activo)
            .toList();
      });
    } catch (e) {
      debugPrint('Error al cargar servicios: $e');
    }
  }

  bool get _isFormComplete =>
      _selectedService != null &&
      _selectedDate != null &&
      _selectedHour != null &&
      _selectedPet != null;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _confirmarReserva() async {
    if (!_isFormComplete) return;
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final bookingProvider = context.read<BookingProvider>();


      // Construir fecha+hora de inicio
      final parts = _selectedHour!.split(':');
      final fechaInicio = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      // Asignar un cuidador si no se proporcionó
      final targetCaregiverUid = _caregiverUid ?? 'sin_asignar';

      final booking = await bookingProvider.createBooking(
        clientUid: auth.currentUser!.uid,
        caregiverUid: targetCaregiverUid,
        petId: _selectedPet!.id,
        serviceId: _selectedService!.id,
        fechaInicio: fechaInicio,
        precioFinal: _selectedService!.precioBase,
        notas: _notasCtrl.text.trim(),
        clienteNombre: auth.currentUser!.nombreCompleto,
        mascotaNombre: _selectedPet!.nombre,
        servicioNombre: _selectedService!.nombre,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reserva enviada exitosamente!'),
          backgroundColor: AppColors.success,
        ),
      );

      context.push('/home/booking-confirm', extra: booking);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear reserva: $e'),
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
    final petProvider = context.watch<PetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reserva'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Servicio
              const Text('Servicio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<ServiceModel>(
                value: _selectedService,
                decoration: const InputDecoration(
                  hintText: 'Selecciona un servicio',
                  prefixIcon: Icon(Icons.miscellaneous_services),
                ),
                items: _services
                    .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                            '${s.nombre} - \$${s.precioBase.toStringAsFixed(0)}')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedService = v),
                validator: (v) => v == null ? 'Selecciona un servicio' : null,
              ),
              const SizedBox(height: 20),

              // Fecha
              const Text('Fecha',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  hintText: _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Selecciona una fecha',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 20),

              // Hora
              const Text('Hora',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _horarios
                    .map((h) => ChoiceChip(
                          label: Text(h),
                          selected: _selectedHour == h,
                          onSelected: (_) =>
                              setState(() => _selectedHour = h),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: _selectedHour == h
                                ? Colors.white
                                : Colors.black,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Mascota
              const Text('Mascota',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<PetModel>(
                value: _selectedPet,
                decoration: const InputDecoration(
                  hintText: 'Selecciona una mascota',
                  prefixIcon: Icon(Icons.pets),
                ),
                items: petProvider.availablePets
                    .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text('${p.nombre} (${p.raza})')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPet = v),
                validator: (v) => v == null ? 'Selecciona una mascota' : null,
              ),
              const SizedBox(height: 20),

              // Notas
              const Text('Notas (opcional)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notasCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Información adicional para el cuidador',
                ),
              ),
              const SizedBox(height: 24),

              // Texto helper
              if (!_isFormComplete)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Selecciona fecha, hora y mascota para continuar',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Botón confirmar
              PrimaryButton(
                label: 'Confirmar reserva',
                isLoading: _isLoading,
                onPressed: _isFormComplete && !_isLoading
                    ? _confirmarReserva
                    : null,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
