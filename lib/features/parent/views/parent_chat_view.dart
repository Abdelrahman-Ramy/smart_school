import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/chats/services/firebase_chat_service.dart';
import 'package:smart_school/features/chats/views/chat_view.dart';

class ParentChatView extends StatefulWidget {
  const ParentChatView({super.key});

  @override
  State<ParentChatView> createState() => _ParentChatViewState();
}

class _ParentChatViewState extends State<ParentChatView> {
  final FirebaseChatService chatService = FirebaseChatService();
  final TextEditingController searchController = TextEditingController();

  String searchText = "";

  Map<String, DateTime> lastChatTime = {};

  @override
  Widget build(BuildContext context) {
    final myId = chatService.currentUserId;

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
          title: Text('All Teachers', style: AppStyle.font22BlackW500),
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search teacher...",
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
                stream: chatService.streamUsersByRole("parent"),
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
                        return const Center(child: Text("No teachers found"));
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                Icons.person,
                                color: AppColors.whiteColor,
                              ),
                            ),

                            title: Text('Mr. ${user['name']}'),

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
            ),
          ],
        ),
      ),
    );
  }
}
