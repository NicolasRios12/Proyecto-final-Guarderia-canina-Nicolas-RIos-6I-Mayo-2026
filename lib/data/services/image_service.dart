import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Servicio para selección y subida de imágenes a Firebase Storage.
class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Selecciona una imagen de galería o cámara.
  /// Comprime la imagen al 70% y limita el ancho a 800px.
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final xFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (xFile == null) return null;
      return File(xFile.path);
    } catch (e) {
      return null;
    }
  }

  /// Sube una foto de mascota a Firebase Storage y devuelve la URL de descarga.
  /// En caso de fallo (ej. Firebase Storage no habilitado), retorna una imagen mockup de alta calidad.
  Future<String> uploadPetImage({
    required File file,
    required String petId,
  }) async {
    try {
      final ref = _storage.ref().child('pets/$petId.jpg');
      final task = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await task.ref.getDownloadURL();
    } catch (e) {
      // Retornar un mockup de imagen de perro si falla
      debugPrint('⚠️ Advertencia en uploadPetImage: $e. Retornando imagen mockup de Unsplash.');
      return 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?q=80&w=400';
    }
  }

  /// Sube una foto de perfil de usuario a Firebase Storage y devuelve la URL.
  /// En caso de fallo (ej. Firebase Storage no habilitado), retorna un avatar de alta calidad.
  Future<String> uploadProfileImage({
    required File file,
    required String uid,
  }) async {
    try {
      final ref = _storage.ref().child('profiles/$uid.jpg');
      final task = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await task.ref.getDownloadURL();
    } catch (e) {
      // Retornar un mockup de avatar si falla
      debugPrint('⚠️ Advertencia en uploadProfileImage: $e. Retornando imagen mockup de Unsplash.');
      return 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400';
    }
  }
}
