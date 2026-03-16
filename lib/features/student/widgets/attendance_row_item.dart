import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class AttendanceRowItem extends StatelessWidget {
  final String subject;
  final int absences;

  const AttendanceRowItem({
    super.key,
    required this.subject,
    required this.absences,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 60.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: AppStyle.font18WhiteW500.copyWith(
              color: AppColors.blackColor
            ),
          ),
          Text(
            absences.toString(),
            style: AppStyle.font18WhiteW500.copyWith(
              color: AppColors.blackColor
            ),
          ),
        ],
      ),
    );
  }
}
