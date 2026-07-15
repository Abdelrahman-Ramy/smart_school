import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/chats/services/firebase_chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;

  const ChatScreen({super.key, required this.otherUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseChatService _chatService = FirebaseChatService();

  final TextEditingController messageController = TextEditingController();

  String? chatId;
  Future<void> initChat() async {
    final id = await _chatService.createOrGetDirectChat(widget.otherUserId);

    setState(() {
      chatId = id;
    });
  }

  @override
  void initState() {
    super.initState();
    initChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Chat", style: AppStyle.font22BlackW500),
        iconTheme: const IconThemeData(color: AppColors.blackColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.beigeLightColor,
              child: Center(
                child: chatId == null
                    ? const Center(child: CircularProgressIndicator())
                    : StreamBuilder(
                        stream: _chatService.streamMessages(chatId!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final messages = snapshot.data!;

                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.all(10.w),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];

                              final isMe =
                                  msg['senderId'] == _chatService.currentUserId;

                              return Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.h),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? AppColors.primaryColor
                                        : AppColors.greyVeryLightColor,
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Text(
                                    msg['text'] ?? '',
                                    style: TextStyle(
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: AppColors.greyVeryLightColor,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        border: InputBorder.none,
                        hintStyle: AppStyle.font15GreyW500,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.whiteColor, size: 20.sp),
                    onPressed: () async {
                      if (messageController.text.isEmpty || chatId == null)
                        return;

                      await _chatService.sendMessage(
                        chatId: chatId!,
                        text: messageController.text.trim(),
                      );

                      messageController.clear();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
