import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class StudentChatBotView extends StatelessWidget {
  const StudentChatBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back, color: Colors.transparent,),
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
              const Spacer(),
              Center(
                child: Text(
                  "What's on your mind today?",
                  style: AppStyle.font25BlackBold.copyWith(fontSize: 24.sp),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),
              const buildChatInput(),
              Gap(15.h),
              Text(
                'SmartBot can make mistakes. Check important info.',
                style: AppStyle.font15GreyW500,
                textAlign: TextAlign.center,
              ),

              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class buildChatInput extends StatefulWidget {
  const buildChatInput({super.key});

  @override
  State<buildChatInput> createState() => _buildChatInputState();
}

// ignore: camel_case_types
class _buildChatInputState extends State<buildChatInput> {
  final TextEditingController chatController = TextEditingController();
  bool isTyping = false;

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
          Icon(CupertinoIcons.add, color: AppColors.blackColor, size: 24.sp),
          Gap(10.w),
          Expanded(
            child: TextField(
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
                chatController.clear();
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
            Icon(
              CupertinoIcons.mic_circle,
              color: AppColors.blackColor,
              size: 30.sp,
            )
        ],
      ),
    );
  }
}
