import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/teacher/widgets/custom_class_card.dart';

class ViewClassesView extends StatefulWidget {
  const ViewClassesView({super.key});

  @override
  State<ViewClassesView> createState() => _ViewClassesViewState();
}

class _ViewClassesViewState extends State<ViewClassesView> {
  String selectedYear = '2025/2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('My Classes', style: AppStyle.font22BlackW500),
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Gap(20.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text('All Classes', style: AppStyle.font14WhiteBold),
                ),
                Gap(10.w),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      showMenu<String>(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          details.globalPosition.dx + 1.w,
                          0,
                        ),
                        items: [
                          const PopupMenuItem(
                            value: '2023/2024',
                            child: Text('2023/2024'),
                          ),
                          const PopupMenuItem(
                            value: '2024/2025',
                            child: Text('2024/2025'),
                          ),
                          const PopupMenuItem(
                            value: '2025/2026',
                            child: Text('2025/2026'),
                          ),
                          const PopupMenuItem(
                            value: '2026/2027',
                            child: Text('2026/2027'),
                          ),
                        ],
                        elevation: 8.0,
                      ).then((value) {
                        if (value != null) {
                          setState(() => selectedYear = value);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greyVeryLightColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Academic Year:$selectedYear',
                            style: AppStyle.font14GreyW400,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 24.sp,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const CustomClassCard(
                    className: 'Grade 6-Maths',
                    section: 'Section A',
                    studentCount: '32 students',
                    time: '10:00-11:00Am',
                  );
                },
              ),
            ),
            Gap(10.h),
            Text(
              "You Don't Have Any Classes Yet",
              style: AppStyle.font14GreyW400,
            ),
            Gap(15.h),
            MaterialButton(
              onPressed: () {},
              minWidth: double.infinity,
              height: 54.h,
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white),
                  Gap(5.w),
                  Text('Create New Class', style: AppStyle.font18WhiteW500),
                ],
              ),
            ),
            Gap(30.h),
          ],
        ),
      ),
    );
  }
}
