import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/features/parent/views/parent_chat_view.dart';
import 'package:smart_school/features/parent/views/parent_home_view.dart';
import 'package:smart_school/features/parent/views/parent_notifications_view.dart';
import 'package:smart_school/features/parent/views/parent_profile_view.dart';

class ParentRoot extends StatefulWidget {
  const ParentRoot({super.key});

  @override
  State<ParentRoot> createState() => _ParentRootState();
}

class _ParentRootState extends State<ParentRoot> {
  late final PageController controller;

  late final List<Widget> screens;
  int currentScreen = 0;
  @override
  void initState() {
    screens = [
      const ParentHomeView(),
      const ParentChatView(),
      const ParentNotificationsView(),
      const ParentProfileView(),
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
                icon: Icon(CupertinoIcons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_circle),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
