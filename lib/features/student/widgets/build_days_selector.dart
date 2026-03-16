import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class BuildDaysSelector extends StatefulWidget {
  const BuildDaysSelector({super.key});

  @override
  State<BuildDaysSelector> createState() => _BuildDaysSelectorState();
}

class _BuildDaysSelectorState extends State<BuildDaysSelector> {
  String selectedDay = 'Sun';
  final List<String> days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 50.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => Gap(8.w),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day == selectedDay;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = day;
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                day,
                style: AppStyle.font16BlackBold.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
