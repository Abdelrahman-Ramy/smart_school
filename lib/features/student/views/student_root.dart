import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/features/student/views/student_chat_bot_view.dart';
import 'package:smart_school/features/student/views/student_home_view.dart';
import 'package:smart_school/features/student/views/student_notifications_view.dart';
import 'package:smart_school/features/student/views/student_settings_view.dart';

class StudentRoot extends StatefulWidget {
  const StudentRoot({super.key});

  @override
  State<StudentRoot> createState() => _StudentRootState();
}

class _StudentRootState extends State<StudentRoot> {
  late final PageController controller;

  late final List<Widget> screens;
  int currentScreen = 0;
  @override
  void initState() {
    screens = [
      const StudentHomeView(),
      const StudentChatBotView(),
      const StudentNotificationsView(),
      const StudentSettingsView(),
    ];
    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: screens,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: currentScreen,
            onTap: (index) {
              setState(() => currentScreen = index);
              controller.jumpToPage(currentScreen);
            },
            elevation: 0,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.whiteColor,
            unselectedItemColor: Colors.grey.shade500,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.smart_toy),
                label: 'Chat Bot',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
