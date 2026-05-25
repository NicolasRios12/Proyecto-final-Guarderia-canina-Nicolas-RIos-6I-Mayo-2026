import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de mensaje de chat.
/// Subcolección Firestore: `chats/{chatId}/messages/{msgId}`.
class MessageModel {
  final String id;
  final String chatId;
  final String senderUid;
  final String text;
  final DateTime timestamp;
  final bool leido;

  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderUid,
    required this.text,
    required this.timestamp,
    required this.leido,
  });

  /// Crea un MessageModel desde un mapa de Firestore.
  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      chatId: map['chat_id'] as String? ?? '',
      senderUid: map['sender_uid'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
              DateTime.now(),
      leido: map['leido'] as bool? ?? false,
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_uid': senderUid,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'leido': leido,
    };
  }

  /// Crea una copia del modelo con campos modificados.
  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderUid,
    String? text,
    DateTime? timestamp,
    bool? leido,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderUid: senderUid ?? this.senderUid,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      leido: leido ?? this.leido,
    );
  }
}
