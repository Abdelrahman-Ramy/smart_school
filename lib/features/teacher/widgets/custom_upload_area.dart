import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomUploadArea extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomUploadArea({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 10.h
        ),
        padding: EdgeInsets.all(8.dg),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey[200]!, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload,
              color: AppColors.primaryColor,
              size: 45.sp,
            ),
            Gap(10.h),
            Text(
              'Upload Files or Drag & Drop Here',
              style: AppStyle.font14GreyW400.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(4.h),
            Text(
              'PDF, DOCX, XLSX, PNG up to 20MB',
              style: AppStyle.font14GreyW400.copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}
