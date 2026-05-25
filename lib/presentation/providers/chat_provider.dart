import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/models/chat_model.dart';
import '../../data/repositories/chat_repository.dart';

/// Provider de estado global para chats.
class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepo = ChatRepository();

  List<ChatModel> _chats = [];
  bool _isLoading = false;
  StreamSubscription? _sub;

  List<ChatModel> get chats => _chats;
  bool get isLoading => _isLoading;

  /// Inicia la escucha de chats del usuario.
  void startListening(String uid) {
    _isLoading = true;
    notifyListeners();

    _sub?.cancel();
    _sub = _chatRepo.getChatsForUser(uid).listen(
      (chats) {
        _chats = chats;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error en stream de chats: $e');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Obtiene o crea un chat entre dos usuarios y devuelve el chatId.
  Future<String> getOrCreateChat({
    required String uid1,
    required String uid2,
  }) async {
    try {
      return await _chatRepo.getOrCreateChat(uid1: uid1, uid2: uid2);
    } catch (e) {
      throw Exception('Error al obtener/crear chat: $e');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
