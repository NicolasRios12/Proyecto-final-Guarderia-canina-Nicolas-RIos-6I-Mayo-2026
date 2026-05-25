import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/chat_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../data/repositories/chat_repository.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_shimmer.dart';

/// Pantalla de lista de conversaciones del usuario.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<ChatModel>>(
        stream: ChatRepository().getChatsForUser(auth.currentUser!.uid),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer();
          }
          if (snap.hasError) {
            return const EmptyState(
                message: 'Error al cargar chats',
                icon: Icons.error_outline);
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const EmptyState(
              message: 'Sin conversaciones',
              subtitle: 'Las conversaciones aparecerán aquí cuando reserves un servicio',
              icon: Icons.chat_bubble_outline,
            );
          }

          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (_, i) {
              final chat = snap.data![i];
              final otherUid =
                  chat.otherParticipant(auth.currentUser!.uid);
              return FutureBuilder<UserModel?>(
                future: UserRepository().getUser(otherUid),
                builder: (_, userSnap) {
                  final other = userSnap.data;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          other?.fotoUrl.isNotEmpty == true
                              ? NetworkImage(other!.fotoUrl)
                              : null,
                      backgroundColor: AppColors.lightBlue,
                      child: other?.fotoUrl.isEmpty == true
                          ? Text(
                              other!.nombre.isNotEmpty
                                  ? other.nombre[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold))
                          : other == null
                              ? const Icon(Icons.person,
                                  color: AppColors.primary)
                              : null,
                    ),
                    title: Text(
                        other?.nombreCompleto ?? 'Cargando...',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      chat.lastMessage.isNotEmpty
                          ? chat.lastMessage
                          : 'Sin mensajes aún',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    trailing: Text(
                        DateHelper.formatRelative(chat.updatedAt),
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                    onTap: () => context.push(
                        '/home/chat/${chat.id}?otherUid=$otherUid'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
