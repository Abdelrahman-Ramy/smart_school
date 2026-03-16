import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/grade_card.dart';

class QuizzesView extends StatelessWidget {
  const QuizzesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Quizzes', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          children: [
            Gap(20.h),
            Text(
              ' Check your latest quizzes and continue\n where you left off :',
              style: AppStyle.font20BlackW500
            ),
             Gap(15.h),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 160.h),
                  itemCount: 9,
                  separatorBuilder: (_, _) => Gap(12.h),
                  itemBuilder: (context, index) {
                    return const GradeCard(
                      colorSubject: AppColors.greyColor,
                      backgroundColor: AppColors.beigeLightColor,
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
    );
  }
}
