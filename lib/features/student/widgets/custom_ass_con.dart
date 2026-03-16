import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomAssCon extends StatelessWidget {
  final String priority;
  final String title;
  final String progress;
  final String statusTitle;
  final String status;
  final Color colorPriority;
  final IconData? iconData;
  final IconData? statusIcon;
  final Color? iconDataColor;
  final TextStyle? statusStyle;

  const CustomAssCon({
    super.key,
    required this.priority,
    required this.title,
    required this.progress,
    required this.statusTitle,
    required this.colorPriority,
    required this.status,
    this.iconData,
    this.statusIcon,
    this.iconDataColor,
    this.statusStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h, left: 12.w, right: 12.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.beigeDarkColor,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: colorPriority, size: 20.sp),
              Gap(8.w),
              Text(
                priority,
                style: AppStyle.font20BlackW500.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.sp
                ),
              ),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Icon(iconData ?? CupertinoIcons.doc_text, size: 26.sp),
              Gap(10.w),
              Expanded(
                child: Text(
                  title,
                  style: AppStyle.font25BlackBold.copyWith(
                    fontSize: 24.sp
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Gap(10.h),
          Text(progress, style: AppStyle.font16BlackBold.copyWith(
            fontSize: 17.sp,
          )),
          Gap(12.h),
          Row(
            children: [
              Icon(
                statusIcon ?? CupertinoIcons.paperclip,
                size: 18.sp,
                color: iconDataColor ?? AppColors.blackColor,
              ),
              Gap(5.w),
              Text(statusTitle, style: AppStyle.font16BlackBold),
            ],
          ),
          Gap(5.h),
          Padding(
            padding: EdgeInsets.only(left: 23.w),
            child: Text(
              status,
              style:
                  statusStyle ??
                  AppStyle.font16Red
            ),
          ),
        ],
      ),
    );
  }
}
