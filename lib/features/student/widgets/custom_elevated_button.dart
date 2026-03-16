import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomElevatedButton extends StatelessWidget {
  final String textButt;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? fontColor;
  final void Function() onPressed;
  const CustomElevatedButton({
    super.key,
    required this.textButt,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed, 
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          textButt,
          style: AppStyle.font14WhiteBold.copyWith(
            color:fontColor ?? AppColors.blackColor),
        ),
      ),
    );
  }
}
