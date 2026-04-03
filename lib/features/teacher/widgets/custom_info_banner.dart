import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomInfoBanner extends StatelessWidget {
  final String text;
  const CustomInfoBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red, size: 18.sp),
          Gap(8.w),
          Text(text, style: TextStyle(color: const Color(0xFF0369A1), fontSize: 12.sp)),
        ],
      ),
    );
  }
}