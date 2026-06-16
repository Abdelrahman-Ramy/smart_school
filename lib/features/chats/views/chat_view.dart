import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/chats/services/firebase_chat_service.dart';

class ChatView extends StatefulWidget {
  final String chatId;
  final String otherUserName;

  const ChatView({
    super.key,
    required this.chatId,
    required this.otherUserName,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final FirebaseChatService chatService = FirebaseChatService();

  final TextEditingController messageController = TextEditingController();

  Future<void> markMessagesAsRead() async {
    final myId = chatService.currentUserId;

    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId);

    final messagesRef = chatRef.collection('messages');

    final snapshot = await messagesRef.where('isRead', isEqualTo: false).get();

    for (var doc in snapshot.docs) {
      if (doc['senderId'] != myId) {
        await doc.reference.update({'isRead': true});
      }
    }

    await chatRef.update({'unread_$myId': 0});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      markMessagesAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.otherUserName,
            style: AppStyle.font20BlackW500.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: chatService.streamMessages(widget.chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  final messages = snapshot.data!;

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        "No Messages Yet",
                        style: AppStyle.font15GreyW500,
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.all(15.w),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index];

                      final isMe =
                          data["senderId"] == chatService.currentUserId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          constraints: BoxConstraints(maxWidth: 260.w),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primaryColor
                                : AppColors.greyVeryLightColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Text(
                            data["text"] ?? "",
                            style: isMe
                                ? AppStyle.font14WhiteBold
                                : AppStyle.font15BlackBold,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: AppStyle.font15GreyW500,
                        filled: true,
                        fillColor: AppColors.greyVeryLightColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  Gap(10.w),

                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.primaryColor,
                    child: IconButton(
                      onPressed: () async {
                        if (messageController.text.trim().isEmpty) return;

                        await chatService.sendMessage(
                          chatId: widget.chatId,
                          text: messageController.text.trim(),
                        );

                        messageController.clear();
                      },
                      icon: const Icon(Icons.send, color: AppColors.whiteColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
