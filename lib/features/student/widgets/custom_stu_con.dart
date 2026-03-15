import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomStuCon extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onTap;
  const CustomStuCon({super.key, required this.text, required this.icon, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.w,
        height: 90.h,
        decoration: BoxDecoration(
          color: AppColors.glassyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 35.sp),
              Gap(10.w),
              Text(text, style: AppStyle.font19BlackW500),
            ],
          ),
        ),
      ),
    );
  }
}
