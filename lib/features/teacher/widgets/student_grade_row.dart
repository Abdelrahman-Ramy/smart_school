import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/teacher/widgets/grade_input_box.dart';

class StudentGradeRow extends StatelessWidget {
  final String name;
  final String rollNo;
  final String totalMarks;

  const StudentGradeRow({
    super.key,
    required this.name,
    required this.rollNo,
    required this.totalMarks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyle.font15BlackBold),
                Gap(5.h),
                Text('Roll No: $rollNo', style: AppStyle.font14GreyW400.copyWith(fontSize: 13.sp)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Obtained Marks', style: AppStyle.font14GreyW400.copyWith(fontSize: 12.5.sp)),
              Gap(4.h),
              Row(
                children: [
                  const GradeInputBox(), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Text('|', style: AppStyle.font14GreyW400),
                  ),
                  GradeInputBox(hint: totalMarks, readOnly: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}