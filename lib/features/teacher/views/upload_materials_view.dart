import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/features/teacher/widgets/custom_attachment_section.dart';
import 'package:smart_school/features/teacher/widgets/custom_simple_class_card.dart';
import 'package:smart_school/features/teacher/widgets/custom_task_field.dart';

class UploadMaterialsView extends StatefulWidget {
  const UploadMaterialsView({super.key});

  @override
  State<UploadMaterialsView> createState() => _UploadGradesViewState();
}

class _UploadGradesViewState extends State<UploadMaterialsView> {
  PlatformFile? pickedFile;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text('Upload Materials', style: AppStyle.font22BlackW500),
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
              const CustomTaskField(
                label: 'lesson Title',
                hintText: 'Multiplication.',
              ),
              const CustomTaskField(
                label: 'Description',
                hintText: 'Provide a brief description of the lesson....',
                maxLines: 3,
              ),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Attachment',
                  style: AppStyle.font14GreyW400.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ),
              CustomAttachmentSection(
                onFileChanged: (file) {
                  setState(() {
                    pickedFile = file;
                  });
                },
              ),
              Gap(110.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
                child: AppTextButton(
                  buttonText: 'Upload Materials',
                  backgroundColor: AppColors.primaryColor,
                  textStyle: AppStyle.font18WhiteW500.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  onPressed: () {},
                ),
              ),
              Gap(10.h),
            ],
          ),
        ),
        
      ),
    );
  }
}
