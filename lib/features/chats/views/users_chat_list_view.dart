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
            return const Center(child: CircularProgressIndicator());
          }

          final myRole = roleSnapshot.data!;

          return StreamBuilder(
            stream: chatService.streamUsersByRole(myRole),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!
                  .where((u) => u['id'].toString() != myId)
                  .toList();

              if (users.isEmpty) {
                return const Center(child: Text("No users found"));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: Text(user['name'][0]),
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['role']),

                    onTap: () async {
                      final chatId = await chatService
                          .createOrGetDirectChat(user['id'].toString());

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatView(
                            chatId: chatId,
                            otherUserName: user['name'],
                          ),
                        ),
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