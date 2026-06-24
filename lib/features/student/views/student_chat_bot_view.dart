import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/chatbot/data/chat_storage.dart';
import 'package:smart_school/features/chatbot/views/chat_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StudentChatBotView extends StatefulWidget {
  const StudentChatBotView({super.key});

  @override
  State<StudentChatBotView> createState() => _StudentChatBotViewState();
}

class _StudentChatBotViewState extends State<StudentChatBotView>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> messages = [];
  final ChatService chatService = ChatService();
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;

  void sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    setState(() {
      messages.add({"text": question, "isUser": true});

      isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    // ChatStorage.saveMessages(messages);

    try {
      final answer = await chatService.sendMessage(question);

      setState(() {
        messages.add({"text": answer, "isUser": false});

        isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      // ChatStorage.saveMessages(messages);
    } catch (e) {
      print("ERROR HAPPENED: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // void loadChat() async {
  //   final savedMessages = await ChatStorage.loadMessages();

  //   setState(() {
  //     messages = savedMessages;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back, color: Colors.transparent),
          backgroundColor: AppColors.whiteColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: Text('SmartBot', style: AppStyle.font22BlackW500),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Text(
                          "What's on your mind today?",
                          style: AppStyle.font25BlackBold.copyWith(
                            fontSize: 24.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(top: 10.h),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return Align(
                            alignment: message["isUser"]
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: message["isUser"]
                                    ? AppColors.primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                message["text"],
                                style: AppStyle.font16BlackBold.copyWith(
                                  fontSize: 15.sp,
                                  color: message["isUser"]
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                          radius: 10.r,
                        ),
                      ),
                      Gap(10.w),
                      Text(
                        "SmartBot is typing...",
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),

              buildChatInput(onSend: sendMessage),

              Gap(12.h),

              Text(
                'SmartBot can make mistakes. Check important info.',
                style: AppStyle.font15GreyW500,
                textAlign: TextAlign.center,
              ),
              Gap(5.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class buildChatInput extends StatefulWidget {
  final Function(String) onSend;

  const buildChatInput({super.key, required this.onSend});

  @override
  State<buildChatInput> createState() => _buildChatInputState();
}

// ignore: camel_case_types
class _buildChatInputState extends State<buildChatInput> {
  final TextEditingController chatController = TextEditingController();
  bool isTyping = false;
  late stt.SpeechToText speech;
  bool isListening = false;
  String selectedLang = "en_US";
  void startListening() async {
    bool available = await speech.initialize();

    if (available && !isListening) {
      setState(() {
        isListening = true;
      });

      speech.listen(
        localeId: selectedLang,
        pauseFor: const Duration(seconds: 2),
        onResult: (result) {
          setState(() {
            chatController.text = result.recognizedWords;
            isTyping = result.recognizedWords.trim().isNotEmpty;
          });
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    setState(() {
      isListening = false;
      isTyping = chatController.text.trim().isNotEmpty;
    });
  }

  void toggleLanguage() {
    setState(() {
      if (selectedLang == "en_US") {
        selectedLang = "ar_EG";
      } else {
        selectedLang = "en_US";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 35,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (isListening) {
                stopListening();
              } else {
                startListening();
              }
            },
            child: Icon(
              isListening ? Icons.mic : CupertinoIcons.mic_circle,
              color: isListening ? Colors.red : AppColors.blackColor,
              size: isListening ? 33.sp : 32.sp,
              
            ),
          ),

          Gap(10.w),

          Expanded(
            child: TextField(
              cursorColor: AppColors.primaryColor,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: chatController,
              onChanged: (val) {
                setState(() {
                  isTyping = val.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Ask anything',
                hintStyle: AppStyle.font18GreyW500.copyWith(fontSize: 16.sp),
                border: InputBorder.none,
              ),
            ),
          ),

          if (isTyping)
            GestureDetector(
              onTap: () {
                final text = chatController.text.trim();

                if (text.isEmpty) return;
                widget.onSend(text);
                chatController.clear();
                FocusScope.of(context).unfocus();
                setState(() {
                  isTyping = false;
                });
              },
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.blackColor,
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedLang == "en_US") {
                    selectedLang = "ar_EG";
                  } else {
                    selectedLang = "en_US";
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedLang == "en_US" ? "EN" : "AR",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
