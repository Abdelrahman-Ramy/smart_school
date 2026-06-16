import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/chats/services/firebase_chat_service.dart';
import 'chat_view.dart';

class UsersChatListView extends StatelessWidget {
  UsersChatListView({super.key});

  final FirebaseChatService chatService = FirebaseChatService();

  @override
  Widget build(BuildContext context) {
    final myId = chatService.currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chats", style: AppStyle.font22BlackW500),
        backgroundColor: AppColors.primaryColor,
      ),

      body: FutureBuilder<String?>(
        future: chatService.getMyRole(),
        builder: (context, roleSnapshot) {
          if (!roleSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          return StreamBuilder(
            stream: chatService.streamMyChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              final chats = snapshot.data!;

              chats.sort((a, b) {
                final aUnread = a['unread_$myId'] ?? 0;
                final bUnread = b['unread_$myId'] ?? 0;

                if (aUnread > 0 && bUnread == 0) return -1;
                if (aUnread == 0 && bUnread > 0) return 1;

                final aTime = a['updatedAt'] as Timestamp?;
                final bTime = b['updatedAt'] as Timestamp?;

                if (aTime == null && bTime == null) return 0;
                if (aTime == null) return 1;
                if (bTime == null) return -1;

                return bTime.millisecondsSinceEpoch.compareTo(
                  aTime.millisecondsSinceEpoch,
                );
              });

              if (chats.isEmpty) {
                return const Center(child: Text("No chats found"));
              }

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  final participants = List<String>.from(chat['participants']);

                  final otherId = participants.firstWhere((id) => id != myId);

                  final unread = chat['unread_$myId'] ?? 0;

                  return FutureBuilder(
                    future: chatService.getUserById(otherId),
                    builder: (context, userSnap) {
                      final user = userSnap.data;
                      final name = user?.name ?? "Loading...";
                      final lastMessage = (chat['lastMessage'] ?? '')
                          .toString();

                      print("LAST MESSAGE = ${chat['lastMessage']}");
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          child: Text(name.isNotEmpty ? name[0] : "?"),
                        ),

                        title: Text(name),

                        subtitle: Text(
                          lastMessage.isEmpty ? 'No messages yet' : lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        trailing: unread > 0
                            ? CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Text(
                                  unread.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : null,

                        onTap: () async {
                          final chatId = await chatService
                              .createOrGetDirectChat(otherId);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatView(chatId: chatId, otherUserName: name),
                            ),
                          );
                        },
                      );
                    },
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
