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

  static const List<Map<String, dynamic>> _dummyLessons = [
    {
      'lessonColor': AppColors.primaryColor,
      'lessonSubject': 'English - Grammar',
      'lessonTime': '08:00 AM - 10:00 AM',
      'classroom': 'A12',
    },
    {
      'lessonColor': Colors.blue,
      'lessonSubject': 'Mathematics - Calculus',
      'lessonTime': '10:15 AM - 11:45 AM',
      'classroom': 'B04',
    },
    {
      'lessonColor': Colors.green,
      'lessonSubject': 'Biology - Lab',
      'lessonTime': '12:00 PM - 01:30 PM',
      'classroom': 'Lab 2',
    },
    {
      'lessonColor': Colors.orange,
      'lessonSubject': 'Arabic - Literature',
      'lessonTime': '01:45 PM - 03:15 PM',
      'classroom': 'C01',
    },
    {
      'lessonColor': Colors.purple,
      'lessonSubject': 'History - Civilization',
      'lessonTime': '03:30 PM - 05:00 PM',
      'classroom': 'A08',
    },
  ];

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
              itemCount: _dummyLessons.length,
              separatorBuilder: (_, _) => Gap(12.h),
              itemBuilder: (context, index) {
                final lesson = _dummyLessons[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: LessonCard(
                    lessonColor: lesson['lessonColor'],
                    lessonSubject: lesson['lessonSubject'],
                    lessonTime: lesson['lessonTime'],
                    classroom: lesson['classroom'],
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
