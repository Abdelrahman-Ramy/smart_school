import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomClassCard extends StatelessWidget {
  final String className;
  final String section;
  final String studentCount;
  final String time;

  const CustomClassCard({
    super.key,
    required this.className,
    required this.section,
    required this.studentCount,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.glassyColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            className,
            style: AppStyle.font18GreyW500.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(4.h),
          Row(
            children: [
              Text(section, style: AppStyle.font15BlackBold),
              Gap(4.w),
              Icon(
                Icons.location_on,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          Gap(12.h),
          const Divider(color: AppColors.greyLightColor, thickness: 1),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.group,
                    size: 18.sp,
                    color: AppColors.greyColor,
                  ),
                  Gap(6.w),
                  Text(
                    studentCount,
                    style: AppStyle.font14GreyW400.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    size: 18.sp,
                    color: AppColors.greyColor,
                  ),
                  Gap(6.w),
                  Text(
                    time,
                    style: AppStyle.font14GreyW400.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildActionItem(CupertinoIcons.person_badge_plus, 'Attendance'),
              buildActionItem(CupertinoIcons.doc_text, 'View Grades'),
              buildActionItem(CupertinoIcons.layers, 'Materials'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildActionItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.blackColor),
        Gap(4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
