import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class GradsCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String percentage;
  final IconData icon;
  const GradsCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.percentage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppColors.glassyColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Gap(10.w),
          Icon(icon, size: 35.sp, color: AppColors.primaryColor),
          Gap(10.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: ' $title\n',
                  style: AppStyle.font16BlackBold.copyWith(fontSize: 17.sp),
                ),
                TextSpan(text: subTitle, style: AppStyle.font14GreyW400),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '$percentage%',
            style: AppStyle.font16BlackBold.copyWith(fontSize: 17.sp),
          ),
          Gap(20.w),
        ],
      ),
    );
  }
}
