import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class AttendanceCard extends StatefulWidget {
  const AttendanceCard({super.key});

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  bool isPresent = true;
  @override
  Widget build(BuildContext context) {
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
          CircleAvatar(
            radius: 25.r,
            backgroundColor: Colors.blue[50],
            child: const Icon(Icons.person, color: AppColors.blueLightColor),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ahmed Hassan', style: AppStyle.font16BlackBold),
                Text('Roll No: 1', style: AppStyle.font14GreyW400),
              ],
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
                isPresent ? const Text(
                  'Present',
                  style: TextStyle(
                    color:  AppColors.greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                ) : const Text(
                  'Absent',
                  style: TextStyle(
                    color:  AppColors.greyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ) ,
                Gap(8.w),
                Switch(
                  value: isPresent,
                  onChanged: (v) {
                    setState(() {
                      isPresent = v;
                    });
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
