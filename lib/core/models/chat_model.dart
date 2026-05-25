import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de conversación de chat.
/// Colección Firestore: `chats/{chatId}`.
class ChatModel {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime updatedAt;

  const ChatModel({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });

  /// Devuelve el UID del otro participante del chat.
  String otherParticipant(String myUid) =>
    participants.firstWhere((p) => p != myUid, orElse: () => '');

  /// Crea un ChatModel desde un mapa de Firestore.
  factory ChatModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['last_message'] as String? ?? '',
      updatedAt: map['updated_at'] is Timestamp
          ? (map['updated_at'] as Timestamp).toDate()
          : DateTime.tryParse(map['updated_at']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  /// Convierte el modelo a mapa para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'last_message': lastMessage,
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  /// Crea una copia del modelo con campos modificados.
  ChatModel copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
