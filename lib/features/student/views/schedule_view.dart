import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/build_days_selector.dart';
import 'package:smart_school/features/student/widgets/lesson_card.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final List<String> days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Schedule', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: Column(
        children: [
          Gap(20.h),
          const BuildDaysSelector(),
          Gap(10.h),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: 160.h),
              itemCount: 9,
              separatorBuilder: (_, _) => Gap(12.h),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: const LessonCard(
                    lessonColor: AppColors.primaryColor,
                    lessonSubject: 'English-Grammer',
                    lessonTime: '08:00AM-10:00AM',
                    classroom: 'A12',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
