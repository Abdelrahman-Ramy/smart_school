import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/notification_tile.dart';

class ParentNotificationsView extends StatefulWidget {
  const ParentNotificationsView({super.key});

  @override
  State<ParentNotificationsView> createState() =>
      _ParentNotificationsViewState();
}

class _ParentNotificationsViewState extends State<ParentNotificationsView> {
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
                      "He is ready for the finals,Ali made great progress.",
                  time: 'Just now',
                  icon: Icons.person,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),
                NotificationTile(
                  title: 'Announcement',
                  subtitle:
                      'New practice material has been sent to Ali',
                  time: '30 min',
                  icon: Icons.campaign,
                  iconColor: AppColors.primaryColor,
                  isRead: true,
                ),
                NotificationTile(
                  title: 'Attendance',
                  subtitle: 'Attendance report for Ali Gomaa Is available',
                  time: 'Mon',
                  icon: Icons.how_to_reg,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),
                NotificationTile(
                  title: 'Garde',
                  subtitle:
                      'have been updates Ali is making excellent progress this semester!',
                  time: 'Just now',
                  icon: Icons.grade,
                  iconColor: AppColors.primaryColor,
                  isRead: true,
                ),
                NotificationTile(
                  title: 'Attendance',
                  subtitle: 'Attendance report for Ali Gomaa Is available',
                  time: 'Mon',
                  icon: Icons.how_to_reg,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),NotificationTile(
                  title: 'Mrs.mai',
                  subtitle:
                      "He is ready for the finals,Ali made great progress.",
                  time: 'Just now',
                  icon: Icons.person,
                  iconColor: AppColors.primaryColor,
                  isRead: false,
                ),
                NotificationTile(
                  title: 'Announcement',
                  subtitle:
                      'New practice material has been sent to Ali',
                  time: '30 min',
                  icon: Icons.campaign,
                  iconColor: AppColors.primaryColor,
                  isRead: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
