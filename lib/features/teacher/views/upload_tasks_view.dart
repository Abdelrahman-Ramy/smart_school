import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/features/teacher/widgets/custom_attachment_section.dart';
import 'package:smart_school/features/teacher/widgets/custom_simple_class_card.dart';
import 'package:smart_school/features/teacher/widgets/custom_task_field.dart';

class UploadTasksView extends StatefulWidget {
  final String classId;
  final String assignmentId;

  const UploadTasksView({
    super.key,
    required this.classId,
    required this.assignmentId,
  });

  @override
  State<UploadTasksView> createState() => _UploadTasksViewState();
}

class _UploadTasksViewState extends State<UploadTasksView> {
  PlatformFile? pickedFile;
  bool isUploading = false;
  String? currentAssignmentId;

  final TeacherRepo _teacherRepo = TeacherRepo();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentAssignmentId = widget.assignmentId;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitAssignment() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dueDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Please fill all required fields',
          icon: CupertinoIcons.info,
          color: AppColors.greyColor,
        ),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final dynamic responseData = await _teacherRepo.uploadAssignment(
        teacherId: '11',
        classId: widget.classId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDateController.text.trim(),
        maxScore: '100',
        type: 'homework',
        filePath: pickedFile?.path,
      );

      if (responseData != null &&
          (responseData['success'] == true || responseData.success == true) &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Assignment uploaded successfully!',
            icon: Icons.check,
            color: Colors.green.shade900,
          ),
        );

        setState(() {
          if (responseData is Map) {
            currentAssignmentId = responseData['data']?['id']?.toString() ?? '';
          } else {
            try {
              currentAssignmentId = responseData.data?.id?.toString() ?? '';
            } catch (_) {
              currentAssignmentId = '';
            }
          }
        });
      } else if (responseData != null && mounted) {
        final String serverMessage =
            responseData['message'] ?? 'Validation failed';
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: serverMessage,
            icon: CupertinoIcons.exclamationmark_triangle,
            color: Colors.orange.shade900,
          ),
        );
      }
    } catch (e) {
      String errorMsg = 'Failed to upload assignment';
      if (e is ApiError) {
        errorMsg = e.message;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: errorMsg,
            icon: CupertinoIcons.info,
            color: Colors.red.shade900,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isUploading = false);
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
          actions: [
            IconButton(
              onPressed: () {
                print("🚨 [DEBUG] Clicked Submissions Button");
                print("🚨 [DEBUG] currentAssignmentId: '$currentAssignmentId'");
                print("🚨 [DEBUG] classId: '${widget.classId}'");

                if (currentAssignmentId == null ||
                    currentAssignmentId!.isEmpty) {
                  print(
                    "❌ [DEBUG] Stopped because currentAssignmentId is NULL or EMPTY!",
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnackbar(
                      errorMsg:
                          'Cannot open! ID is empty: $currentAssignmentId',
                      icon: CupertinoIcons.info,
                      color: AppColors.greyColor,
                    ),
                  );
                  return;
                }

                print(
                  "🚀 [DEBUG] All IDs valid! Navigating to assignmentSubmissions...",
                );
                Navigator.of(context).pushNamed(
                  Routes.assignmentSubmissions,
                  arguments: {
                    'assignmentId': currentAssignmentId!,
                    'classId': widget.classId,
                  },
                );
              },
              icon: Icon(
                Icons.assignment_turned_in_outlined,
                color: AppColors.blackColor,
                size: 24.sp,
              ),
            ),
          ],
          elevation: 0,
          title: Text('Upload Tasks', style: AppStyle.font22BlackW500),
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
                title: 'Create New Assignment',
                description: 'Fill in the details to assign a new task.',
              ),
              CustomTaskField(
                controller: _titleController,
                label: 'Task Title',
                hintText: 'Home Work 5:.............',
              ),
              CustomTaskField(
                controller: _descriptionController,
                label: 'Description',
                hintText: 'Provide a brief description...',
                maxLines: 3,
              ),
              CustomTaskField(
                controller: _dueDateController,
                label: 'Due Date',
                hintText: 'Select due date (YYYY-MM-DD)',
                readOnly: true,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
                onTap: () => _selectDueDate(context),
              ),
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
              Gap(10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
                child: isUploading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : AppTextButton(
                        buttonText: 'Upload Task',
                        backgroundColor: AppColors.primaryColor,
                        textStyle: AppStyle.font18WhiteW500.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: _submitAssignment,
                      ),
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
