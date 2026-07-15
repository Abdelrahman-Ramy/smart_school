import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/teacher/cubit/upload_assignment_cubit.dart';
import 'package:smart_school/features/teacher/cubit/upload_assignment_state.dart';
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
  bool _showAttachmentField = false;
  String? currentAssignmentId;
  bool isFormValid = false;

  final TeacherRepo _teacherRepo = TeacherRepo();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController(
    text: '100',
  );
  late final UploadAssignmentCubit _uploadCubit;
  String classTitle = 'Loading...';
  String classDescription = '';
  int? classStudentsCount;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _maxScoreController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    _uploadCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentAssignmentId = widget.assignmentId;
    _uploadCubit = UploadAssignmentCubit(_teacherRepo);

    _titleController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _dueDateController.addListener(_validateForm);
    _maxScoreController.addListener(_validateForm);

    _loadClassDetails();
  }

  void _validateForm() {
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();
    final due = _dueDateController.text.trim();
    final max = _maxScoreController.text.trim();
    final fileOk = !_showAttachmentField || (pickedFile != null);
    final valid =
        title.isNotEmpty &&
        desc.isNotEmpty &&
        due.isNotEmpty &&
        max.isNotEmpty &&
        fileOk;
    if (valid != isFormValid && mounted) {
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
    // validation guard
    _validateForm();
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Please fill all required fields',
          icon: CupertinoIcons.info,
          color: AppColors.greyColor,
        ),
      );
      return;
    }

    _uploadCubit.uploadAssignment(
      teacherId: PrefHelper.getUserId() ?? '11',
      classId: widget.classId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _dueDateController.text.trim(),
      maxScore: _maxScoreController.text.trim(),
      type: 'homework',
      filePath: pickedFile?.path,
    );
  }
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
>>>>>>> aa255c4e198149f3f192b9c73d020e7d3c5707aa
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
          title: Text('Upload Tasks', style: AppStyle.font22BlackW500),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              color: AppColors.blackColor,
              size: 26.sp,
              CupertinoIcons.chevron_back,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                
                Navigator.of(context).pushNamed(
                  Routes.assignmentSubmissions,
                  arguments: {
                    'assignmentId': currentAssignmentId!,
                    'classId': widget.classId,
                  },
                );
              },
              child: Text(
                'View Student Submissions',
                style: AppStyle.font14GreyW400.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSimpleClassCard(
                title: classTitle,
                description: (() {
                  final parts = <String>[];
                  if (classDescription.isNotEmpty) parts.add(classDescription);
                  if (classStudentsCount != null)
                    parts.add('${classStudentsCount} students');
                  return parts.isNotEmpty
                      ? parts.join(' • ')
                      : 'Create New Assignment - Fill in the details to assign a new task.';
                })(),
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
              CustomTaskField(
                controller: _maxScoreController,
                label: 'Max Score',
                hintText: 'Enter max score (e.g. 100)',
              ),
              if (!_showAttachmentField)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 5.h,
                  ),
                  child: AppTextButton(
                    buttonText: 'Upload Task',
                    backgroundColor: AppColors.primaryColor,
                    textStyle: AppStyle.font18WhiteW500.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      setState(() {
                        _showAttachmentField = true;
                      });
                    },
                  ),
                ),
              if (_showAttachmentField) ...[
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
                Gap(10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 5.h,
                  ),
                  child: BlocProvider<UploadAssignmentCubit>(
                    create: (_) => _uploadCubit,
                    child:
                        BlocListener<
                          UploadAssignmentCubit,
                          UploadAssignmentState
                        >(
                          listener: (context, state) {
                            if (state is UploadAssignmentSuccess) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackbar(
                                    errorMsg: state.message,
                                    icon: Icons.check,
                                    color: Colors.green.shade900,
                                  ),
                                );

                                // try to extract new assignment id if present in response data
                                try {
                                  final res = state.data;
                                  final id = res is Map
                                      ? (res['data']?['id']?.toString() ?? '')
                                      : '';
                                  if (id.isNotEmpty) {
                                    setState(() {
                                      currentAssignmentId = id;
                                    });
                                  }
                                } catch (_) {}

                                Navigator.of(context).pop();
                              }
                            } else if (state is UploadAssignmentFailure) {
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
                          child:
                              BlocBuilder<
                                UploadAssignmentCubit,
                                UploadAssignmentState
                              >(
                                builder: (context, state) {
                                  final submitting =
                                      state is UploadAssignmentSubmitting;
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
                                              buttonText: 'Create Assignment',
                                              backgroundColor: isFormValid
                                                  ? AppColors.primaryColor
                                                  : Colors.grey,
                                              textStyle: AppStyle
                                                  .font18WhiteW500
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              onPressed: _submitAssignment,
                                            ),
                                          ),
                                        );
                                },
                              ),
                        ),
                  ),
                ),
              ],
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
