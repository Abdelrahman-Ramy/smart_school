import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/network/dio_client.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/teacher/cubit/submission_search_cubit.dart';
import 'package:smart_school/features/teacher/cubit/submission_search_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignmentSubmissionsView extends StatefulWidget {
  final String assignmentId;
  final String classId;

  const AssignmentSubmissionsView({
    super.key,
    required this.assignmentId,
    required this.classId,
  });

  @override
  State<AssignmentSubmissionsView> createState() =>
      _AssignmentSubmissionsViewState();
}

class _AssignmentSubmissionsViewState extends State<AssignmentSubmissionsView> {
  final TeacherRepo _teacherRepo = TeacherRepo();
  late final SubmissionSearchCubit _searchCubit;

  final TextEditingController _taskIdController = TextEditingController();

  final Map<int, TextEditingController> _gradeControllers = {};
  final Map<int, bool> _isSaving = {};

  @override
  void initState() {
    super.initState();
    _searchCubit = SubmissionSearchCubit(_teacherRepo);
  }

  Future<void> _openSubmissionFile(String filePath) async {
    final DioClient client = DioClient();
    final String baseUrl = client.dio.options.baseUrl;
    final String trimmedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    if (filePath.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'No file to open',
            icon: CupertinoIcons.info,
            color: AppColors.greyColor,
          ),
        );
      }
      return;
    }

    final String fullUrl;
    if (filePath.toLowerCase().startsWith('http')) {
      fullUrl = filePath;
    } else {
      final cleaned = filePath.replaceFirst(RegExp(r'^/+'), '');
      fullUrl = '$trimmedBase$cleaned';
    }

    final Uri url = Uri.tryParse(fullUrl) ?? Uri();

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (launched != true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Could not open file',
            icon: CupertinoIcons.info,
            color: AppColors.greyColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Error launching file',
            icon: CupertinoIcons.info,
            color: AppColors.greyColor,
          ),
        );
      }
    }
  }

  void _showSubmissionDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.primaryColor,
                        child: Text(
                          item.student.user.name.isNotEmpty
                              ? item.student.user.name[0].toUpperCase()
                              : 'S',
                          style: const TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.student.user.name,
                              style: AppStyle.font19BlackW500,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Student ID: ${item.studentId}",
                              style: AppStyle.font15GreyW400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.picture_as_pdf,
                        color: AppColors.redColor,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item.filePath.split('/').last,
                          style: AppStyle.font15GreyW500,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                      SizedBox(width: 8.w),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _openSubmissionFile(item.filePath);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text('Open'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _taskIdController.dispose();
    for (final c in _gradeControllers.values) {
      c.dispose();
    }
    _searchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Student Submissions', style: AppStyle.font22BlackW500),
      ),

      body: BlocProvider<SubmissionSearchCubit>(
        create: (_) => _searchCubit,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskIdController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.redColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                        labelText: 'Task ID',
                        labelStyle: TextStyle(color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  ElevatedButton(
                    onPressed: () {
                      final String taskId = _taskIdController.text.trim();

                      if (taskId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter valid Task ID')),
                        );
                        return;
                      }
                      _searchCubit.searchByTaskId(taskId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text('Search', style: AppStyle.font14WhiteBold),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
              Expanded(
                child: BlocBuilder<SubmissionSearchCubit, SubmissionSearchState>(
                  builder: (context, state) {
                    if (state is SubmissionSearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (state is SubmissionSearchFailure) {
                      return Center(child: Text(state.error));
                    }

                    if (state is SubmissionSearchSuccess) {
                      final submissions = state.submissions;

                      return ListView.builder(
                        itemCount: submissions.length,
                        itemBuilder: (context, index) {
                          final item = submissions[index];
                          final sid = item.id;

                          _gradeControllers.putIfAbsent(
                            sid,
                            () => TextEditingController(
                              text: item.score == 0
                                  ? ''
                                  : item.score.toString(),
                            ),
                          );

                          _isSaving.putIfAbsent(sid, () => false);

                          final controller = _gradeControllers[sid]!;

                          return Card(
                            color: AppColors.glassyColor,
                            margin: EdgeInsets.symmetric(vertical: 6.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ================= TOP INFO =================
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18.r,
                                        backgroundColor: AppColors.primaryColor,
                                        child: Text(
                                          item.student.user.name.isNotEmpty
                                              ? item.student.user.name[0]
                                                    .toUpperCase()
                                              : 'S',
                                          style: const TextStyle(
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.student.user.name,
                                              style: AppStyle.font18WhiteW500,
                                            ),
                                            Text(
                                              "Student ID: ${item.studentId}",
                                              style: AppStyle.font14GreyW400,
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.score > 0
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Text(
                                          item.score > 0 ? "Graded" : "Pending",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: item.score > 0
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  // ================= FILE =================
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          item.filePath.split('/').last,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            _openSubmissionFile(item.filePath),
                                        child: const Text("Open"),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  // ================= GRADE =================
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: controller,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            labelText: "Grade",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 8.w),

                                      _isSaving[sid] == true
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primaryColor,
                                              ),
                                              onPressed: () async {
                                                final text = controller.text
                                                    .trim();
                                                if (text.isEmpty) return;

                                                setState(
                                                  () => _isSaving[sid] = true,
                                                );

                                                final studentIdForApi =
                                                    item
                                                        .student
                                                        .studentCode
                                                        .isNotEmpty
                                                    ? item.student.studentCode
                                                    : item.studentId.toString();

                                                final success = await _teacherRepo
                                                    .gradeAssignment(
                                                      submissionId: sid
                                                          .toString(),
                                                      assignmentId:
                                                          widget.assignmentId,
                                                      studentId:
                                                          studentIdForApi,
                                                      score: text,
                                                      feedback: '',
                                                      teacherId:
                                                          PrefHelper.getUserId() ??
                                                          '11',
                                                      classId: widget.classId,
                                                    );

                                                if (!mounted) return;

                                                setState(
                                                  () => _isSaving[sid] = false,
                                                );

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      success
                                                          ? "Saved"
                                                          : "Failed",
                                                    ),
                                                  ),
                                                );

                                                if (success) {
                                                  _searchCubit.searchByTaskId(
                                                    _taskIdController.text
                                                        .trim(),
                                                  );
                                                }
                                              },
                                              child: Text(
                                                "Save",
                                                style: AppStyle.font14WhiteBold,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Center(
                      child: Text('Enter Task ID and press Search'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
