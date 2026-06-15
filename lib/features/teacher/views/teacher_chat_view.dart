import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/chats/views/chat_view.dart';
import 'package:smart_school/features/chats/services/firebase_chat_service.dart';

class TeacherChatView extends StatefulWidget {
  const TeacherChatView({super.key});

  @override
  State<TeacherChatView> createState() => _TeacherChatViewState();
}

class _TeacherChatViewState extends State<TeacherChatView> {
  final FirebaseChatService chatService = FirebaseChatService();

  Map<String, DateTime> lastChatTime = {};
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final myId = chatService.currentUserId;

    if (myId == null || myId.isEmpty) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          leading: const Icon(Icons.arrow_back, color: Colors.transparent),
          title: Text('All Parents', style: AppStyle.font22BlackW500),
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search user...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: chatService.streamUsersByRole("teacher"),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var users = snapshot.data!;

                  // remove self
                  users = users
                      .where((u) => u['id'].toString() != myId)
                      .toList();

                  // search
                  if (searchText.isNotEmpty) {
                    users = users.where((u) {
                      final name = u['name'].toString().toLowerCase();
                      return name.contains(searchText.toLowerCase());
                    }).toList();
                  }

                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .where('participants', arrayContains: myId)
                        .snapshots(),
                    builder: (context, chatSnap) {
                      if (chatSnap.hasData) {
                        lastChatTime.clear();

                        for (var doc in chatSnap.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;

                          final participants = List<String>.from(
                            data['participants'],
                          );

                          final otherId = participants.firstWhere(
                            (id) => id != myId,
                          );

                          final time =
                              data['updatedAt']?.toDate() ?? DateTime(0);

                          lastChatTime[otherId] = time;
                        }

                        users.sort((a, b) {
                          final aTime =
                              lastChatTime[a['id'].toString()] ?? DateTime(0);

                          final bTime =
                              lastChatTime[b['id'].toString()] ?? DateTime(0);

                          return bTime.compareTo(aTime);
                        });
                      }

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
                              child: Text(
                                user['name'][0].toString().toUpperCase(),
                                style: AppStyle.font16BlackBold.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),

                            title: Text(
                              user['name'],
                              style: AppStyle.font18WhiteW500.copyWith(
                                color: AppColors.blackColor,
                              ),
                            ),

                            subtitle: Text(user['role'] ?? ""),

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
            ),
          ],
        ),
      ),
    );
  }
}
