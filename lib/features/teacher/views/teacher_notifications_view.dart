import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/notification_tile.dart';

class TeacherNotificationsView extends StatefulWidget {
  const TeacherNotificationsView({super.key});

  @override
  State<TeacherNotificationsView> createState() =>
      _TeacherNotificationsViewState();
}

class _TeacherNotificationsViewState extends State<TeacherNotificationsView> {
  bool isAllSelected = true;

  final List<Map<String, dynamic>> teacherNotificationsData = [
    {
      'title': 'Mrs.mai',
      'subtitle':
          "Great lesson today!\nenjoyed the practice exercise,\nThank You.",
      'time': 'Just now',
      'icon': Icons.person,
      'isRead': false,
    },
    {
      'title': 'Announcement',
      'subtitle': 'Remember to review the last\nfew lessons in preparation',
      'time': '30 min',
      'icon': Icons.campaign,
      'isRead': true,
    },
    {
      'title': 'Mrs.Mona',
      'subtitle': 'sent you a message\n',
      'time': 'Mon',
      'icon': Icons.notifications,
      'isRead': false,
    },
    {
      'title': 'Dashboard',
      'subtitle': 'Breakdowns have been updates\n',
      'time': 'Just now',
      'icon': Icons.bar_chart,
      'isRead': true,
    },
    {
      'title': 'Mr.Mohamed',
      'subtitle': "I want toThank You for Your Efforts.",
      'time': 'Just now',
      'icon': Icons.person,
      'isRead': false,
    },
    {
      'title': 'Announcement',
      'subtitle': 'Remember to review the last\nfew lessons in preparation',
      'time': '30 min',
      'icon': Icons.campaign,
      'isRead': true,
    },
    {
      'title': 'Announcement',
      'subtitle': 'Remember to review the last\nfew lessons in preparation',
      'time': '30 min',
      'icon': Icons.campaign,
      'isRead': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentList = isAllSelected
        ? teacherNotificationsData
        : teacherNotificationsData
              .where((item) => item['isRead'] == false)
              .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.transparent),
        title: Text('Notifications', style: AppStyle.font22BlackW500),
      ),
      body: Column(
        children: [
          Gap(10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isAllSelected = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isAllSelected
                              ? AppColors.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'All',
                          style: isAllSelected
                              ? AppStyle.font14WhiteBold.copyWith(
                                  fontSize: 16.sp,
                                )
                              : AppStyle.font16BlackBold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isAllSelected = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !isAllSelected
                              ? AppColors.primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'UnRead',
                          style: !isAllSelected
                              ? AppStyle.font14WhiteBold.copyWith(
                                  fontSize: 16.sp,
                                )
                              : AppStyle.font16BlackBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(20.h),
          Expanded(
            child: currentList.isEmpty
                ? Center(
                    child: Text(
                      'No Unread Notifications',
                      style: AppStyle.font16BlackBold.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: currentList.length,
                    itemBuilder: (context, index) {
                      final item = currentList[index];
                      return NotificationTile(
                        title: item['title'],
                        subtitle: item['subtitle'],
                        time: item['time'],
                        icon: item['icon'],
                        iconColor: AppColors.primaryColor,
                        isRead: item['isRead'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
