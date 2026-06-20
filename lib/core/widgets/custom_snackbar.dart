import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

SnackBar customSnackbar({
  required String errorMsg,
  IconData? icon,
  required Color color,
}) {
  return SnackBar(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    margin: EdgeInsets.only(bottom: 30.h, right: 20.w, left: 20.w),
    elevation: 20,
    behavior: SnackBarBehavior.floating,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    backgroundColor: color,
    content: Row(
      children: [
        Icon(icon, color: AppColors.whiteColor,),
        Gap(5.w),
        Expanded(child: Text(errorMsg, style: AppStyle.font13White500)),
      ],
    ),
  );
}
