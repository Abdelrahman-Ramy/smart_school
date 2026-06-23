import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class QuizzesView extends StatelessWidget {
  const QuizzesView({super.key});

  static const List<Map<String, dynamic>> _dummyUploadedMaterials = [
    {
      'colorSubject': AppColors.primaryColor,
      'backgroundColor': AppColors.beigeLightColor,
      'lessonTitle': 'Multiplication.',
      'description': 'Provide a brief description of the lesson....',
      'fileSize': 14,
      'fileExtension': 'PDF',
      'date': '21/06/2026',
      'subject': 'Mathematics',
      'fileName': 'multiplication_ch2_lecture.pdf',
    },
    {
      'colorSubject': Colors.blue,
      'backgroundColor': Color(0xFFE3F2FD),
      'lessonTitle': 'Grammar: Past Simple',
      'description': 'Full lecture notes with answers for sheet 2.',
      'fileSize': 5,
      'fileExtension': 'DOCX',
      'date': '20/06/2026',
      'subject': 'English',
      'fileName': 'past_simple_notes.docx',
    },
    {
      'colorSubject': Colors.green,
      'backgroundColor': Color(0xFFE8F5E9),
      'lessonTitle': 'Plant Cells Structure',
      'description': 'High resolution diagram displaying cell wall functions.',
      'fileSize': 12,
      'fileExtension': 'PNG',
      'date': '19/06/2026',
      'subject': 'Biology',
      'fileName': 'cell_structure_diagram.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Materials', style: AppStyle.font22BlackW500),
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
              ' Check your latest educational materials\n and downloaded files :',
              style: AppStyle.font20BlackW500,
            ),
            Gap(15.h),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 160.h),
                itemCount: _dummyUploadedMaterials.length,
                separatorBuilder: (_, _) => Gap(12.h),
                itemBuilder: (context, index) {
                  final material = _dummyUploadedMaterials[index];
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: material['backgroundColor'],
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
                                color: material['colorSubject'],
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            Gap(10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    material['lessonTitle'],
                                    style: AppStyle.font16BlackBold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gap(4.h),
                                  Text(
                                    material['description'],
                                    style: AppStyle.font14GreyW400.copyWith(color: Colors.black54),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Gap(10.w),
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "${material['fileSize']}",
                                    style: AppStyle.font16BlackBold.copyWith(fontSize: 12.sp),
                                  ),
                                  Text(
                                    material['fileExtension'],
                                    style: AppStyle.font14GreyW400.copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold),
                                  ),
                                ],
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
                                material['fileExtension'] == 'PDF'
                                    ? CupertinoIcons.doc_text_fill
                                    : CupertinoIcons.doc_text,
                                color: material['fileExtension'] == 'PDF'
                                    ? Colors.red.shade700
                                    : AppColors.primaryColor,
                                size: 20.sp,
                              ),
                              Gap(8.w),
                              Expanded(
                                child: Text(
                                  material['fileName'],
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
                        Gap(8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              material['subject'],
                              style: AppStyle.font14GreyW400.copyWith(fontWeight: FontWeight.bold, color: material['colorSubject']),
                            ),
                            Text(
                              material['date'],
                              style: AppStyle.font14GreyW400,
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