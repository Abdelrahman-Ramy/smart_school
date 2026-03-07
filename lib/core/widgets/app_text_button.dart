import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final bool? isNav;
  const AppTextButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonWidth,
    this.buttonHeight,
    required this.buttonText,
    required this.textStyle,
    required this.onPressed,
     this.isNav,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
        ),
        backgroundColor: backgroundColor ?? Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding?.w ?? 12.w,
          vertical: verticalPadding?.h ?? 14.h,
        ),
        fixedSize: Size(
          buttonWidth?.w ?? double.maxFinite,
          buttonHeight ?? 58.h,
        ),
      ),

      child: isNav == true ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(buttonText, style: textStyle),
          Icon(
            Icons.arrow_forward_outlined,
            color: AppColors.primaryColor,
            size: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ):
          Text(buttonText, style: textStyle),
    );
  }
}
