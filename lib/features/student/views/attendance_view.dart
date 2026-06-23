import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/attendance_row_item.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  static const List<Map<String, dynamic>> _dummyAttendance = [
    {'subject': 'English', 'absences': 3},
    {'subject': 'Mathematics', 'absences': 1},
    {'subject': 'Biology', 'absences': 0},
    {'subject': 'Arabic', 'absences': 5},
    {'subject': 'History', 'absences': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Attendance', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: Text(
                'Review all recorded absences across\nsubjects',
                style: AppStyle.font16BlackBold.copyWith(height: 1.5),
              ),
            ),
            Gap(10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  Subject',
                    style: AppStyle.font20BlackW500.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Absences',
                    style: AppStyle.font20BlackW500.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Gap(5.h),
            const Divider(thickness: 0.8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dummyAttendance.length,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 0.8, height: 0),
              itemBuilder: (context, index) {
                final record = _dummyAttendance[index];
                return AttendanceRowItem(
                  subject: record['subject'],
                  absences: record['absences'],
                );
              },
            ),
            const Divider(thickness: 0.8),
            Gap(30.h),
            buildWarningBox(),
            Gap(50.h),
          ],
        ),
      ),
    );
  }

  Widget buildWarningBox() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: AppColors.glassyColor,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              'If you miss more than 4 classes in any subject, you may receive a warning',
              style: AppStyle.font14GreyW400.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            top: -12.h,
            left: -5.w,
            child: Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: AppColors.redColor,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }
}
