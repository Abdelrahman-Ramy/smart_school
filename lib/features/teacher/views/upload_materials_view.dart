import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/features/teacher/widgets/custom_attachment_section.dart';
import 'package:smart_school/features/teacher/widgets/custom_simple_class_card.dart';
import 'package:smart_school/features/teacher/widgets/custom_task_field.dart';

class UploadMaterialsView extends StatefulWidget {
  final String classId;
  const UploadMaterialsView({super.key, required this.classId});

  @override
  State<UploadMaterialsView> createState() => _UploadGradesViewState();
}

class _UploadGradesViewState extends State<UploadMaterialsView> {
  PlatformFile? pickedFile;
  bool isUploading = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TeacherRepo _teacherRepo = TeacherRepo();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _uploadMaterialAction() async {
    final title = titleController.text.trim();
    final file = pickedFile;

    if (title.isEmpty || file == null || file.path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Please enter a title and select a valid local file',
          icon: CupertinoIcons.info,
          color: AppColors.greyColor,
        ),
      );
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final response = await _teacherRepo.uploadMaterial(
        classId: widget.classId,
        title: title,
        filePath: file.path!,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: response.message!,
            icon: Icons.check,
            color: Colors.green.shade900,
          ),
        );
        if (response.success) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Upload failed: $e',
            icon: CupertinoIcons.info,
            color: Colors.red.shade900,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
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
              const CustomSimpleClassCard(
                title: 'Upload New Material',
                description: 'Upload your class files and documents here.',
              ),
              CustomTaskField(
                controller: titleController,
                label: 'lesson Title',
                hintText: 'Multiplication.',
              ),
              CustomTaskField(
                controller: descriptionController,
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
                child: isUploading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : AppTextButton(
                        buttonText: 'Upload Materials',
                        backgroundColor: AppColors.primaryColor,
                        textStyle: AppStyle.font18WhiteW500.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: _uploadMaterialAction,
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
