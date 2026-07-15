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
          leading: const Icon(Icons.arrow_back, color: Colors.transparent),
          elevation: 0,
          centerTitle: true,
          title: Text('All Teachers', style: AppStyle.font22BlackW500),
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: searchController,
                onChanged: (value) => setState(() => searchText = value),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('participants', arrayContains: myId)
                    .orderBy('updatedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chats = snapshot.data!.docs;
                  chats.sort((a, b) {
                    final chatA = a.data() as Map<String, dynamic>;
                    final chatB = b.data() as Map<String, dynamic>;

                    final unreadA = chatA['unread_$myId'] ?? 0;
                    final unreadB = chatB['unread_$myId'] ?? 0;

                    if (unreadA > 0 && unreadB == 0) return -1;
                    if (unreadA == 0 && unreadB > 0) return 1;

                    final timeA = chatA['updatedAt'] as Timestamp?;
                    final timeB = chatB['updatedAt'] as Timestamp?;

                    if (timeA == null && timeB == null) return 0;
                    if (timeA == null) return 1;
                    if (timeB == null) return -1;

                    return timeB.compareTo(timeA);
                  });

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index].data() as Map<String, dynamic>;

                      final participants = List<String>.from(
                        chat['participants'],
                      );

                      final otherId = participants.firstWhere(
                        (id) => id != myId,
                      );

                      final unread = chat['unread_$myId'] ?? 0;

                      return FutureBuilder(
                        future: chatService.getUserById(otherId),
                        builder: (context, userSnap) {
                          if (!userSnap.hasData) {
                            return const ListTile(title: Text("User"));
                          }

                          final name = userSnap.data?.name ?? "User";

                          if (searchText.isNotEmpty &&
                              !name.toLowerCase().contains(
                                searchText.toLowerCase(),
                              )) {
                            return const SizedBox();
                          }

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : "?",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            title: Text(name),

                            subtitle: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(chats[index].id)
                                  .collection('messages')
                                  .orderBy('timestamp', descending: true)
                                  .limit(1)
                                  .get(),
                              builder: (context, msgSnap) {
                                String text = "No messages yet";

                                if (msgSnap.hasData &&
                                    msgSnap.data!.docs.isNotEmpty) {
                                  text = msgSnap.data!.docs.first['text'] ?? "";
                                }

                                return Text(
                                  text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
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
                              final chatId = chats[index].id;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatView(
                                    chatId: chatId,
                                    otherUserName: name,
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
