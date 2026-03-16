import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class LessonCard extends StatelessWidget {
  // final LessonModel lesson;
  final Color lessonColor;
  final String lessonSubject;
  final String lessonTime;
  final String classroom;

  const LessonCard({
    super.key,
    required this.lessonColor,
    required this.lessonSubject,
    required this.lessonTime,
    required this.classroom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w,),
      decoration: BoxDecoration(
        color: AppColors.beigeDarkColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
            width: 6.w,
            height: 70.h,
            decoration: BoxDecoration(
              color: lessonColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
            Gap(20.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lessonSubject,
                      style: AppStyle.font19BlackW500.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    ),
                    Gap(8.h),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        Gap(5.w),
                        Text(
                          lessonTime,
                          style: AppStyle.font15GreyW400.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ],
                    ),
                    Gap(5.h),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.building_2_fill,
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        Gap(5.w),
                        Text(
                          'Classroom: $classroom',
                          style: AppStyle.font15GreyW400.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
