import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomFileCard extends StatelessWidget {
  final String fileName;
  final VoidCallback? onDelete;

  const CustomFileCard({
    super.key,
    required this.fileName,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            color: Colors.orange[400],
            size: 22.sp,
          ),
          Gap(10.w),
          Expanded(
            child: Text(
              fileName,
              style: AppStyle.font14GreyW400.copyWith(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              color: Colors.grey[400],
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}