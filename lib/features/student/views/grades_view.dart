import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/custom_elevated_button.dart';
import 'package:smart_school/features/student/widgets/grade_card.dart';
import 'package:smart_school/features/student/widgets/summary_bar.dart';

class GradesView extends StatelessWidget {
  const GradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Grades', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Column(
            children: [
              Gap(20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' Last Revision Exam', style: AppStyle.font19BlackW500),
                  Text('Date:20 Dec.2025', style: AppStyle.font15GreyW400),
                ],
              ),
              Gap(15.h),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 160.h),
                  itemCount: 9,
                  separatorBuilder: (_, _) => Gap(12.h),
                  itemBuilder: (context, index) {
                    return const GradeCard(
                      colorSubject: AppColors.greenLightColor,
                      isDone: true,
                      title: 'English',
                      subtitle: 'Chapter 1-5',
                      mark: 95,
                      grade: 'A+',
                      date: '13/12/2025',
                      time: '10:30 Am -11:30 Am',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            const SummaryBar(),
            Gap(12.h),
            Row(
              children: [
                CustomElevatedButton(
                  textButt: 'Save',
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: AppColors.blackColor,
                  onPressed: () {},
                ),
                Gap(10.w),
                CustomElevatedButton(
                  textButt: 'Share',
                  backgroundColor: AppColors.greenLightColor,
                  foregroundColor: AppColors.whiteColor,
                  fontColor: AppColors.whiteColor,
                  onPressed: () {},
                ),
              ],
            ),
            Gap(12.h),
          ],
        ),
      ),
    );
  }
}
