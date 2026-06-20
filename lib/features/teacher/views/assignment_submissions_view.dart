import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/data/submission_model.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
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
  late Future<SubmissionResponse> _submissionsFuture;

  @override
  void initState() {
    super.initState();
    _submissionsFuture = _teacherRepo.getAssignmentSubmissions(
      assignmentId: widget.assignmentId,
    );
  }

  void _loadSubmissions() {
    setState(() {
      _submissionsFuture = _teacherRepo.getAssignmentSubmissions(
        assignmentId: widget.assignmentId,
      );
    });
  }

  Future<void> _openSubmissionFile(String filePath) async {
    final String baseUrl = "https://your-api-domain.com/";
    final String fullUrl = filePath.startsWith('http')
        ? filePath
        : "$baseUrl$filePath";

    final Uri url = Uri.parse(fullUrl);
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Could not launch submission file',
          icon: CupertinoIcons.info,
          color: AppColors.greyColor,
        ),
      );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Error launching file: $e',
          icon: CupertinoIcons.info,
          color: AppColors.greyColor,
        ),
      );
      }
    }
  }

  void _showGradeDialog(
    BuildContext context, {
    required String submissionId,
    required String studentId,
    required String currentScore,
    required String currentFeedback,
  }) {
    final TextEditingController scoreController = TextEditingController(
      text: currentScore == '0' ? '' : currentScore,
    );
    final TextEditingController feedbackController = TextEditingController(
      text: currentFeedback,
    );
    final ValueNotifier<bool> isSavingNotifier = ValueNotifier<bool>(false);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            'Grade Submission',
            style: AppStyle.font18GreyW500.copyWith(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Score',
                    hintText: 'e.g. 10',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: feedbackController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Feedback',
                    hintText: 'e.g. Well done!',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                scoreController.dispose();
                feedbackController.dispose();
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.greyColor),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isSavingNotifier,
              builder: (context, isSaving, child) {
                return isSaving
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: () async {
                          if (scoreController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a score!'),
                              ),
                            );
                            return;
                          }

                          isSavingNotifier.value = true;

                          try {
                            final success = await _teacherRepo.gradeAssignment(
                              submissionId: submissionId,
                              assignmentId: widget.assignmentId.toString(),
                              studentId: studentId,
                              score: scoreController.text.trim(),
                              feedback: feedbackController.text.trim(),
                              teacherId: '11',
                              classId: widget.classId.toString(),
                            );

                            if (mounted) {
                              if (success) {
                                scoreController.dispose();
                                feedbackController.dispose();
                                Navigator.pop(dialogContext);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  customSnackbar(
                                    errorMsg: 'Graded successfully!',
                                    icon: Icons.check,
                                    color: Colors.green.shade900,
                                  ),
                                );
                                _loadSubmissions();
                              } else {
                                isSavingNotifier.value = false;
                                ScaffoldMessenger.of(
                                  dialogContext,
                                ).showSnackBar(
                                  customSnackbar(
                                    errorMsg:
                                        'Failed to save grade. Try again.',
                                    icon: CupertinoIcons.info,
                                    color: AppColors.greyColor,
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              isSavingNotifier.value = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                customSnackbar(
                                  errorMsg: 'Error: $e',
                                  icon: CupertinoIcons.info,
                                  color: AppColors.greyColor,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      );
              },
            ),
          ],
        );
      },
    ).then((_) {
      scoreController.dispose();
      feedbackController.dispose();
    });
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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: FutureBuilder<SubmissionResponse>(
        future: _submissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: AppStyle.font14GreyW400.copyWith(
                    color: AppColors.redColor,
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(
              child: Text(
                'No student submitted this task yet.',
                style: AppStyle.font14GreyW400,
              ),
            );
          }

          final submissions = snapshot.data!.data;

          return ListView.builder(
            itemCount: submissions.length,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              final item = submissions[index];
              final bool isGraded = item.status == 'graded';
              final String studentName = item.student.user.name.isNotEmpty
                  ? item.student.user.name
                  : 'Unknown Student';

              return GestureDetector(
                onTap: () {
                  _showGradeDialog(
                    context,
                    submissionId: item.id.toString(),
                    studentId: item.studentId.toString(),
                    currentScore: item.score.toString(),
                    currentFeedback: item.feedback,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  padding: EdgeInsets.all(12.dg),
                  decoration: BoxDecoration(
                    color: isGraded
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isGraded
                          ? AppColors.greenColor
                          : AppColors.orangeColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: isGraded
                            ? AppColors.greenColor.withOpacity(0.2)
                            : AppColors.orangeColor.withOpacity(0.2),
                        child: Text(
                          studentName.isNotEmpty
                              ? studentName[0].toUpperCase()
                              : 'S',
                          style: AppStyle.font15BlackBold.copyWith(
                            color: isGraded
                                ? AppColors.greenColor
                                : AppColors.orangeColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentName, style: AppStyle.font15BlackBold),
                            SizedBox(height: 4.h),
                            Text(
                              'Status: ${item.status.toUpperCase()}',
                              style: AppStyle.font14GreyW400.copyWith(
                                color: isGraded
                                    ? AppColors.greenColor
                                    : AppColors.orangeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.filePath.isNotEmpty)
                        IconButton(
                          onPressed: () => _openSubmissionFile(item.filePath),
                          icon: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red[700],
                            size: 28.sp,
                          ),
                        ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Score', style: AppStyle.font14GreyW400),
                          SizedBox(height: 2.h),
                          Text(
                            isGraded ? '${item.score}/10' : '-/10',
                            style: AppStyle.font15BlackBold.copyWith(
                              color: isGraded
                                  ? AppColors.greenColor
                                  : AppColors.greyColor,
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
        },
      ),
    );
  }
}
