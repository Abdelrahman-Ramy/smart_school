import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/features/teacher/cubit/upload_material_cubit.dart';
import 'package:smart_school/features/teacher/cubit/upload_material_state.dart';
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
  late final UploadMaterialCubit _uploadCubit;

  String classTitle = 'Loading...';
  String classDescription = '';
  int? classStudentsCount;
  bool isFormValid = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    _uploadCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _uploadCubit = UploadMaterialCubit(_teacherRepo);

    titleController.addListener(_validateForm);
    descriptionController.addListener(_validateForm);

    // load class details
    _loadClassDetails();
  }

  void _validateForm() {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    final fileOk = pickedFile != null;
    final valid = title.isNotEmpty && desc.isNotEmpty && fileOk;
    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  Future<void> _loadClassDetails() async {
    if (widget.classId.isEmpty) return;
    final cls = await _teacherRepo.fetchClassById(widget.classId);
    if (cls != null && mounted) {
      setState(() {
        classTitle = cls.className?.isNotEmpty == true
            ? cls.className!
            : (cls.subject ?? cls.className ?? 'Class');
        classDescription = (cls.sectionName ?? '');
        classStudentsCount = cls.studentsCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UploadMaterialCubit>(
      create: (_) => _uploadCubit,
      child: BlocListener<UploadMaterialCubit, UploadMaterialState>(
        listener: (context, state) {
          if (state is UploadMaterialSuccess) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackbar(
                  errorMsg: state.message,
                  icon: Icons.check,
                  color: Colors.green.shade900,
                ),
              );
              Navigator.of(context).pop();
            }
          } else if (state is UploadMaterialFailure) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackbar(
                  errorMsg: state.error,
                  icon: CupertinoIcons.info,
                  color: Colors.red.shade900,
                ),
              );
            }
          }
        },
        child: GestureDetector(
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
                  CustomSimpleClassCard(
                    title: classTitle,
                    description: (() {
                      final parts = <String>[];
                      if (classDescription.isNotEmpty)
                        parts.add(classDescription);
                      if (classStudentsCount != null)
                        parts.add('${classStudentsCount} students');
                      return parts.isNotEmpty
                          ? parts.join(' • ')
                          : 'Upload your class files and documents here.';
                    })(),
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
                      _validateForm();
                    },
                  ),
                  Gap(110.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 5.h,
                    ),
                    child:
                        BlocBuilder<UploadMaterialCubit, UploadMaterialState>(
                          builder: (context, state) {
                            final submitting =
                                state is UploadMaterialSubmitting;
                            return submitting
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : AbsorbPointer(
                                    absorbing: !isFormValid,
                                    child: Opacity(
                                      opacity: isFormValid ? 1.0 : 0.6,
                                      child: AppTextButton(
                                        buttonText: 'Upload Materials',
                                        backgroundColor: isFormValid
                                            ? AppColors.primaryColor
                                            : Colors.grey,
                                        textStyle: AppStyle.font18WhiteW500
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        onPressed: () {
                                          // guard
                                          if (!isFormValid) return;
                                          final file = pickedFile;
                                          if (file == null || file.path == null)
                                            return;
                                          _uploadCubit.uploadMaterial(
                                            classId: widget.classId,
                                            title: titleController.text.trim(),
                                            filePath: file.path!,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                          },
                        ),
                  ),
                  Gap(10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
