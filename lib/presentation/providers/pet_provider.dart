import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';

/// Provider de estado global para mascotas del usuario.
/// Escucha cambios en Firestore mediante StreamSubscription.
class PetProvider extends ChangeNotifier {
  final PetRepository _petRepo = PetRepository();

  List<PetModel> _pets = [];
  bool _isLoading = false;
  StreamSubscription? _sub;

  List<PetModel> get pets => _pets;
  bool get isLoading => _isLoading;

  /// Lista de mascotas disponibles (no en servicio).
  List<PetModel> get availablePets =>
      _pets.where((p) => p.estado == 'disponible').toList();

  /// Inicia la escucha de mascotas del usuario.
  void startListening(String ownerUid) {
    _isLoading = true;
    notifyListeners();

    _sub?.cancel();
    _sub = _petRepo.getUserPets(ownerUid).listen(
      (pets) {
        _pets = pets;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error en stream de mascotas: $e');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Agrega una mascota a Firestore.
  Future<void> addPet(PetModel pet) async {
    try {
      await _petRepo.addPet(pet);
      // El StreamSubscription actualiza la lista automáticamente
    } catch (e) {
      throw Exception('Error al agregar mascota: $e');
    }
  }

  /// Elimina una mascota (solo si no tiene reservas activas).
  Future<void> deletePet(String petId) async {
    final deleted = await _petRepo.deletePet(petId);
    if (!deleted) {
      throw Exception(
          'No se puede eliminar: la mascota tiene reservas activas');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
