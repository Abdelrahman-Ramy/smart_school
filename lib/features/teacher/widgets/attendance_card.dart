import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class AttendanceCard extends StatelessWidget {
  final String studentName;
  final String currentStatus;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onViewHistoryTap;

  const AttendanceCard({
    super.key,
    required this.studentName,
    required this.currentStatus,
    required this.onStatusChanged,
    required this.onViewHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isPresent = currentStatus == 'present';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.dg),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onViewHistoryTap,
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: Colors.blue[50],
              child: const Icon(Icons.person, color: AppColors.blueLightColor),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: GestureDetector(
              onTap: onViewHistoryTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentName, style: AppStyle.font16BlackBold),
                  Text('Tap to view history', style: AppStyle.font14GreyW400),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              color: AppColors.glassyColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Text(
                    isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      color: isPresent
                          ? AppColors.greenColor
                          : AppColors.greyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(8.w),
                Switch(
                  value: isPresent,
                  onChanged: (value) {
                    onStatusChanged(value ? 'present' : 'absent');
                  },
                  activeColor: AppColors.whiteColor,
                  activeTrackColor: AppColors.greenDarkColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
