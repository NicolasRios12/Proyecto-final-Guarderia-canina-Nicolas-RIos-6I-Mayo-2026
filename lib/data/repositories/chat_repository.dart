import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/chat_model.dart';
import '../../core/models/message_model.dart';

/// Repositorio para operaciones de chat en tiempo real con Firestore.
class ChatRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene un chat existente entre dos usuarios o crea uno nuevo.
  /// Devuelve el chatId.
  Future<String> getOrCreateChat({
    required String uid1,
    required String uid2,
  }) async {
    try {
      // Buscar chat existente donde uid1 es participante
      final query = await _db
          .collection('chats')
          .where('participants', arrayContains: uid1)
          .get();

      // Verificar si alguno de los chats contiene también uid2
      for (final doc in query.docs) {
        final participants = List<String>.from(doc.data()['participants']);
        if (participants.contains(uid2)) {
          return doc.id;
        }
      }

      // Crear nuevo chat si no existe
      final chatId = const Uuid().v4();
      await _db.collection('chats').doc(chatId).set({
        'id': chatId,
        'participants': [uid1, uid2],
        'last_message': '',
        'updated_at': Timestamp.now(),
      });

      return chatId;
    } catch (e) {
      throw Exception('Error al obtener/crear chat: $e');
    }
  }

  /// Stream de chats del usuario, ordenados por última actualización.
  Stream<List<ChatModel>> getChatsForUser(String uid) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .snapshots()
        .map((snap) {
          final list = snap.docs
              .map((d) => ChatModel.fromMap(d.data(), d.id))
              .toList();
          list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return list;
        });
  }

  /// Stream de mensajes de un chat, ordenados cronológicamente.
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MessageModel.fromMap(d.data(), d.id))
            .toList());
  }

  /// Envía un mensaje y actualiza el último mensaje del chat en una transacción batch.
  Future<void> sendMessage({
    required String chatId,
    required String senderUid,
    required String text,
  }) async {
    try {
      final msgId = const Uuid().v4();
      final now = Timestamp.now();

      // Transacción: crear mensaje + actualizar chat
      final batch = _db.batch();

      batch.set(
        _db.collection('chats').doc(chatId).collection('messages').doc(msgId),
        {
          'id': msgId,
          'chat_id': chatId,
          'sender_uid': senderUid,
          'text': text,
          'timestamp': now,
          'leido': false,
        },
      );

      batch.update(
        _db.collection('chats').doc(chatId),
        {
          'last_message':
              text.length > 50 ? '${text.substring(0, 50)}...' : text,
          'updated_at': now,
        },
      );

      await batch.commit();
    } catch (e) {
      throw Exception('Error al enviar mensaje: $e');
    }
  }
}
