import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/message_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/repositories/chat_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../providers/auth_provider.dart';

/// Pantalla de chat en tiempo real entre dos usuarios.
/// Usa StreamBuilder para mensajes y auto-scroll al último mensaje.
class ChatRoomScreen extends StatefulWidget {
  final String chatId;
  final String otherUid;

  const ChatRoomScreen({
    super.key,
    required this.chatId,
    required this.otherUid,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageCtrl = TextEditingController();
  final _scrollController = ScrollController();
  UserModel? _otherUser;

  @override
  void initState() {
    super.initState();
    _loadOtherUser();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOtherUser() async {
    try {
      final user = await UserRepository().getUser(widget.otherUid);
      if (mounted) setState(() => _otherUser = user);
    } catch (e) {
      debugPrint('Error al cargar usuario: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;

    _messageCtrl.clear();

    try {
      final auth = context.read<AuthProvider>();
      await ChatRepository().sendMessage(
        chatId: widget.chatId,
        senderUid: auth.currentUser!.uid,
        text: text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar mensaje: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Hace scroll automático al último mensaje.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: _otherUser?.fotoUrl.isNotEmpty == true
                  ? NetworkImage(_otherUser!.fotoUrl)
                  : null,
              backgroundColor: AppColors.lightBlue,
              child: _otherUser?.fotoUrl.isEmpty == true
                  ? Text(
                      _otherUser!.nombre[0].toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12))
                  : _otherUser == null
                      ? const Icon(Icons.person,
                          size: 16, color: AppColors.primary)
                      : null,
            ),
            const SizedBox(width: 8),
            Text(_otherUser?.nombreCompleto ?? 'Chat',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: ChatRepository().getMessages(widget.chatId),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                      child: Text('Error al cargar mensajes: ${snap.error}'));
                }

                final msgs = snap.data ?? [];

                // Auto-scroll al último mensaje
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (msgs.isEmpty) {
                  return const Center(
                    child: Text('Envía el primer mensaje',
                        style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) => _MessageBubble(
                    msg: msgs[i],
                    isMe: msgs[i].senderUid == auth.currentUser!.uid,
                  ),
                );
              },
            ),
          ),
          // Input de mensaje
          _MessageInput(
            controller: _messageCtrl,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

/// Burbuja de mensaje con alineación según remitente.
class _MessageBubble extends StatelessWidget {
  final MessageModel msg;
  final bool isMe;

  const _MessageBubble({required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.divider,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.text,
                style: TextStyle(
                    color: isMe ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(DateHelper.formatTime(msg.timestamp),
                style: TextStyle(
                    fontSize: 11,
                    color: isMe ? Colors.white70 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// Input de mensaje con botón de envío.
class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
