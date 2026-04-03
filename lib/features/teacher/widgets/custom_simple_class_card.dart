import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomSimpleClassCard extends StatelessWidget {
  const CustomSimpleClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
            width: double.infinity,
            margin: EdgeInsets.all(20.dg),
            padding: EdgeInsets.all(10.dg),
            decoration: BoxDecoration(
              color: AppColors.glassyColor,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grade 6-Maths',
                  style: AppStyle.font18GreyW500.copyWith(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(5.h),
                Row(
                  children: [
                    Text('Section A', style: AppStyle.font15BlackBold),
                    Gap(5.w),
                    Icon(
                      Icons.location_on,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
                const Divider(color: AppColors.greyLightColor, thickness: 1),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 20.sp,
                      color: Colors.blueGrey,
                    ),
                    Gap(8.w),
                    Text(
                      'Today, 10 Feb, 2026',
                      style: AppStyle.font14GreyW400.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}