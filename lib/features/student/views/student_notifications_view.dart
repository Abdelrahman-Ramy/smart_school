import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/notification_tile.dart';

class StudentNotificationsView extends StatefulWidget {
  const StudentNotificationsView({super.key});

  @override
  State<StudentNotificationsView> createState() =>
      _StudentNotificationsViewState();
}

class _StudentNotificationsViewState extends State<StudentNotificationsView> {
  bool isAllSelected = true;

  final List<Map<String, dynamic>> studentNotificationsData = [
    {
      'title': 'Mr.Mohamed',
      'subtitle':
          'Extra material has been sent. Make sure to review it before the finals.',
      'time': 'Just now',
      'icon': Icons.notifications,
      'iconColor': AppColors.primaryColor,
      'isRead': false,
    },
    {
      'title': 'Math',
      'subtitle': 'You got A on your latest Math exam. Excellent Work!',
      'time': '30 min',
      'icon': Icons.campaign,
      'iconColor': AppColors.glassyColor,
      'isRead': true,
    },
    {
      'title': 'Grades',
      'subtitle': 'Your overall GPA is 3.5. keep up the great effort!',
      'time': 'Yesterday',
      'icon': Icons.grade,
      'iconColor': AppColors.greenColor,
      'isRead': false,
    },
    {
      'title': 'Science',
      'subtitle': 'You got B+ on your latest Science exam. Excellent Work!',
      'time': 'Mon',
      'icon': Icons.campaign,
      'iconColor': AppColors.glassyColor,
      'isRead': true,
    },
    {
      'title': 'Mrs.Mona',
      'subtitle': 'Mrs.Mona has uploaded new materials. Tap to view',
      'time': 'Mon',
      'icon': Icons.notifications,
      'iconColor': AppColors.primaryColor,
      'isRead': false,
    },
    {
      'title': 'Grades',
      'subtitle': 'Your overall GPA is 3.5. keep up the great effort!',
      'time': 'Yesterday',
      'icon': Icons.grade,
      'iconColor': AppColors.greenColor,
      'isRead': true,
    },
    {
      'title': 'Mr.Mohamed',
      'subtitle':
          'Extra material has been sent. Make sure to review it before the finals.',
      'time': 'Just now',
      'icon': Icons.notifications,
      'iconColor': AppColors.primaryColor,
      'isRead': true,
    },
    {
      'title': 'Math',
      'subtitle': 'You got A on your latest Math exam. Excellent Work!',
      'time': '30 min',
      'icon': Icons.campaign,
      'iconColor': AppColors.glassyColor,
      'isRead': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentList = isAllSelected
        ? studentNotificationsData
        : studentNotificationsData
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
                        iconColor: item['iconColor'],
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
