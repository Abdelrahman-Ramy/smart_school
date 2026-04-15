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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.transparent,),
        title: Text('Notifications', style: AppStyle.font22BlackW500),
      ),
      body: Column(
        children: [
          Gap(10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Container(
              height: 45.h,
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
                              ? AppStyle.font14WhiteBold.copyWith(fontSize: 16.sp)
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
                          'Mentions',
                          style: !isAllSelected
                              ? AppStyle.font14WhiteBold.copyWith(fontSize: 16.sp)
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
            child: ListView(
              children: const [
                NotificationTile(
                  title: 'Mrs.mai',
                  subtitle:
                      "Great lesson today!\nenjoyed the practice exercise,\nThank You.",
                  time: 'Just now',
                  icon: Icons.person,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),
                NotificationTile(
                  title: 'Announcement',
                  subtitle:
                      'Remember to review the last\nfew lessons in preparation',
                  time: '30 min',
                  icon: Icons.campaign,
                  iconColor: AppColors.primaryColor,
                  isRead: true,
                ),
                NotificationTile(
                  title: 'Mrs.Mona',
                  subtitle: 'sent you a message\n',
                  time: 'Mon',
                  icon: Icons.notifications,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                  isClick: true,
                ),
                NotificationTile(
                  title: 'Dashboard',
                  subtitle:
                      'Breakdowns have been updates\n',
                  time: 'Just now',
                  icon: Icons.bar_chart,
                  iconColor: AppColors.primaryColor,
                  isRead: true,
                  isClick: true,
                ),
                NotificationTile(
                  title: 'Mr.Mohamed',
                  subtitle:
                      "I want toThank You for Your Efforts.",
                  time: 'Just now',
                  icon: Icons.person,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),
                 NotificationTile(
                  title: 'Announcement',
                  subtitle:
                      'Remember to review the last\nfew lessons in preparation',
                  time: '30 min',
                  icon: Icons.campaign,
                  iconColor: AppColors.primaryColor,
                  isRead: true,
                ),
                 NotificationTile(
                  title: 'Announcement',
                  subtitle:
                      'Remember to review the last\nfew lessons in preparation',
                  time: '30 min',
                  icon: Icons.campaign,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
