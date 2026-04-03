import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/features/teacher/widgets/custom_info_banner.dart';
import 'package:smart_school/features/teacher/widgets/custom_simple_class_card.dart';
import 'package:smart_school/features/teacher/widgets/exam_header_fields.dart';
import 'package:smart_school/features/teacher/widgets/student_grade_row.dart';

class UploadGradesView extends StatefulWidget {
  const UploadGradesView({super.key});

  @override
  State<UploadGradesView> createState() => _UploadGradesViewState();
}

class _UploadGradesViewState extends State<UploadGradesView> {
  PlatformFile? pickedFile;
  bool isUploading = false;
  final TextEditingController totalMarksController = TextEditingController(
    text: '00',
  );
  final TextEditingController totalController = TextEditingController(
    text: '00',
  );
  final TextEditingController examNameController = TextEditingController(
    text: 'Quiz',
  );

  @override
  void dispose() {
    totalMarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text('Upload Grades', style: AppStyle.font22BlackW500),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              color: AppColors.blackColor,
              size: 26.sp,
              CupertinoIcons.chevron_back,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomSimpleClassCard(),
              ExamHeaderFields(
                totalMarksController: totalMarksController,
                totalMarksNameController: examNameController,
              ),
              Gap(20.h),
              const CustomInfoBanner(
                text: 'Enter the scores for each student below.',
              ),

              ValueListenableBuilder(
                valueListenable: totalMarksController,
                builder: (context, value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return StudentGradeRow(
                          name: 'Omar Ahmed',
                          rollNo: '${index + 1}',
                          totalMarks: totalMarksController.text,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
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
            buttonText: 'Upload Grades',
            backgroundColor: AppColors.primaryColor,
            textStyle: AppStyle.font18WhiteW500.copyWith(
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {},
          ),
        ),
      ),
      ),
    );
  }
}
