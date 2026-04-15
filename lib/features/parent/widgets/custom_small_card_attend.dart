import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomSmallCardAttend extends StatelessWidget {
  final IconData iconData;
  final String percentage;
  final Color iconColor;
  final String text;
  const CustomSmallCardAttend({
    super.key,
    required this.iconData,
    required this.percentage,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.glassyColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            iconData,
            color: iconColor,
            fontWeight: FontWeight.bold,
            size: 55.sp,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$percentage %",
                style: AppStyle.font22BlackW500.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(text, style: AppStyle.font15GreyW500),
            ],
          ),
          Gap(5.w),
        ],
      ),
    );
  }
}
