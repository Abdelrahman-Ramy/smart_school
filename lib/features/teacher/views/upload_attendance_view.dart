import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/features/teacher/widgets/attendance_card.dart';
import 'package:smart_school/features/teacher/widgets/custom_simple_class_card.dart';

class UploadAttendanceView extends StatefulWidget {
  const UploadAttendanceView({super.key});

  @override
  State<UploadAttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<UploadAttendanceView> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Attendance', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.blackColor,
            size: 26.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          const CustomSimpleClassCard(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                buildFilterButton('All', 0),
                Gap(5.w),
                buildFilterButton('Present', 1),
                Gap(5.w),
                buildFilterButton('Absent', 2),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16.sp,
                        color: AppColors.greyColor,
                      ),
                      Gap(5.w),
                      Text('Absent: 00', style: AppStyle.font14GreyW400),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(15.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: 10,
              itemBuilder: (context, index) {
                return const AttendanceCard();
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 15,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 23.h),
          child: AppTextButton(
            buttonText: 'Save Attendance',
            backgroundColor: AppColors.primaryColor,
            textStyle: AppStyle.font18WhiteW500.copyWith(
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget buildFilterButton(String label, int index) {
    bool isSelected = selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppStyle.font14WhiteBold
              : AppStyle.font14GreyW400,
        ),
      ),
    );
  }

 
  }
