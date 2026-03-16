import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class GradeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final int mark;
  final String grade;
  final Color colorSubject;
  final Color? backgroundColor;
  final bool? isDone;

  const GradeCard({
    super.key,
    required this.colorSubject,
    required this.title,
    required this.subtitle,
    required this.mark,
    required this.grade,
    required this.date,
    required this.time,
    this.backgroundColor,
    this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.beigeColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: colorSubject,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.font19BlackW500),
                Gap(6.h),
                Text(subtitle, style: AppStyle.font15GreyW400),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date, style: AppStyle.font15GreyW400),
              Gap(6.h),
              Text(time, style: AppStyle.font15GreyW400),
              Gap(6.h),
              if (isDone == true)
                Row(
                  children: [
                    Text('Marks: ', style: AppStyle.font16BlackBold),
                    Text(
                      '$mark',
                      style: AppStyle.font15BlackBold.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(8.w),
                    Text('Grade:', style: AppStyle.font16BlackBold),
                    Gap(6.w),
                    Text(
                      grade,
                      style: AppStyle.font15BlackBold.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'Not Graded Yet',
                  style: AppStyle.font15BlackBold.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// final List<Map<String, dynamic>> sampleGrades = [
//   {
//     'title': 'Arabic',
//     'subtitle': 'Chapter 1-3',
//     'date': '11/12/2025',
//     'time': '09:30 Am -11:30 Am',
//     'marks': 90,
//     'grade': 'A',
//     'color': AppColors.greenLightColor,
//   },
//   {
//     'title': 'English',
//     'subtitle': 'Chapter 1-5',
//     'date': '13/12/2025',
//     'time': '10:30 Am -11:30 Am',
//     'marks': 95,
//     'grade': 'A+',
//     'color': AppColors.blueLightColor,
//   },
//   {
//     'title': 'Mathematics',
//     'subtitle': 'Chapter 1-3',
//     'date': '15/12/2025',
//     'time': '09:30 Am -11:30 Am',
//     'marks': 96,
//     'grade': 'A+',
//     'color': AppColors.orangeColor,
//   },
//   {
//     'title': 'Science',
//     'subtitle': 'Chapter 1-3',
//     'date': '18/12/2025',
//     'time': '09:30 Am -11:30 Am',
//     'marks': 90,
//     'grade': 'A',
//     'color': AppColors.greenColor,
//   },
//   {
//     'title': 'Social Studies',
//     'subtitle': 'Chapter 1-3',
//     'date': '11/12/2025',
//     'time': '09:30 Am -11:30 Am',
//     'marks': 89,
//     'grade': 'B+',
//     'color': AppColors.blueColor,
//   },
// ];
