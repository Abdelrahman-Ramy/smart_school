import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class AssignmentsView extends StatelessWidget {
  const AssignmentsView({super.key});

  static const List<Map<String, dynamic>> _dummyAssignments = [
    {
      'colorSubject': AppColors.primaryColor,
      'backgroundColor': AppColors.beigeLightColor,
      'priority': 'HIGH PRIORITY',
      'colorPriority': AppColors.redColor,
      'title': 'Home Work 5: Arabic Essay',
      'description': 'Provide a brief description... Write a 500-word essay about digital transformation.',
      'dueDate': '2026-06-25',
      'teacherAttachment': 'Essay_Guidelines.pdf',
      'subject': 'Arabic',
    },
    {
      'colorSubject': Colors.blue,
      'backgroundColor': Color(0xFFE3F2FD),
      'priority': 'MEDIUM PRIORITY',
      'colorPriority': Colors.orange,
      'title': 'Home Work 6: Algebra Ch3',
      'description': 'Complete all exercises on page 45 regarding quadratic equations.',
      'dueDate': '2026-06-28',
      'teacherAttachment': 'Algebra_Ch3_Equations.pdf',
      'subject': 'Mathematics',
    },
    {
      'colorSubject': Colors.green,
      'backgroundColor': Color(0xFFE8F5E9),
      'priority': 'LOW PRIORITY',
      'colorPriority': Colors.green,
      'title': 'Home Work 2: Biology Cell Lab',
      'description': 'Draw and label the plant cell structure based on yesterday\'s lab work.',
      'dueDate': '2026-07-02',
      'teacherAttachment': 'Lab_Template.docx',
      'subject': 'Biology',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Assignments', style: AppStyle.font22BlackW500),
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
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 160.h),
                itemCount: _dummyAssignments.length,
                separatorBuilder: (_, _) => Gap(12.h),
                itemBuilder: (context, index) {
                  final assignment = _dummyAssignments[index];
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: assignment['backgroundColor'],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 10.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: assignment['colorSubject'],
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assignment['title'],
                                    style: AppStyle.font16BlackBold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gap(4.h),
                                  Text(
                                    assignment['description'],
                                    style: AppStyle.font14GreyW400.copyWith(color: Colors.black54),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Gap(10.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: assignment['colorPriority'].withOpacity(0.3)),
                              ),
                              child: Text(
                                assignment['priority'],
                                style: AppStyle.font14WhiteBold.copyWith(
                                  color: assignment['colorPriority'],
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.doc_text,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                              Gap(8.w),
                              Expanded(
                                child: Text(
                                  assignment['teacherAttachment'],
                                  style: AppStyle.font14GreyW400.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Gap(10.w),
                              Icon(
                                CupertinoIcons.cloud_download,
                                color: Colors.grey.shade700,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                        Gap(10.h),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: assignment['colorSubject'].withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.cloud_upload,
                                  color: assignment['colorSubject'],
                                  size: 18.sp,
                                ),
                                Gap(8.w),
                                Text(
                                  'Upload Your Solution',
                                  style: AppStyle.font16BlackBold.copyWith(
                                    color: assignment['colorSubject'],
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              assignment['subject'],
                              style: AppStyle.font14GreyW400.copyWith(
                                fontWeight: FontWeight.bold, 
                                color: assignment['colorSubject']
                              ),
                            ),
                            Text(
                              "Due: ${assignment['dueDate']}",
                              style: AppStyle.font14GreyW400.copyWith(
                                color: AppColors.redColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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