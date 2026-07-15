import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/cubits/assignment_cubit.dart';
import 'package:smart_school/features/student/cubits/assignment_state.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class AssignmentsView extends StatefulWidget {
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
  State<AssignmentsView> createState() => _AssignmentsViewState();
}

class _AssignmentsViewState extends State<AssignmentsView> {
  // ================= TIME =================

  DateTime _parseDate(String date) {
    return DateTime.parse(date).toLocal();
  }

  int hoursLeft(String dueDate) {
    final due = _parseDate(dueDate);
    final now = DateTime.now();
    return due.difference(now).inHours;
  }

  String getStatus(String dueDate, bool submitted) {
    if (submitted) return "SUBMITTED";

    final hours = hoursLeft(dueDate);

    if (hours < 0) return "OVERDUE";
    if (hours <= 48) return "HIGH";
    if (hours <= 120) return "MEDIUM";
    return "LOW";
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "OVERDUE ":
        return AppColors.greyColor;
      case "SUBMITTED":
        return AppColors.greenColor;
      case "HIGH":
        return AppColors.redColor;
      case "MEDIUM":
        return AppColors.orangeColor;
      default:
        return AppColors.greyColor;
    }
  }

  // ================= FILE =================

  Future<void> openFile(String? path) async {
    try {
      const dummyUrl =
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";

      final viewer =
          "https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(dummyUrl)}";

      await launchUrl(Uri.parse(viewer), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("openFile error: $e");
    }
  }

  Future<String?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result == null || result.files.isEmpty) return null;

      return result.files.single.path;
    } catch (_) {
      return null;
    }
  }

  String fileName(String path) => path.split('/').last;

  static const List<Color> cardColors = [
    AppColors.blueLightColor,
    AppColors.greenLightColor,
    AppColors.orangeColor,
    AppColors.purpleColor,
    AppColors.tealColor,
    AppColors.redColor,
  ];

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssignmentCubit(StudentRepo())..getAssignments(),
      child: BlocListener<AssignmentCubit, AssignmentState>(
        listenWhen: (prev, curr) => true,
        listener: (context, state) {
          if (state is AssignmentUploadSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                customSnackbar(
                  errorMsg: "Assignment submitted successfully",
                  icon: Icons.check,
                  color: Colors.green.shade900,
                ),
              );
          }

          if (state is AssignmentAlreadySubmitted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                customSnackbar(
                  errorMsg: "Already submitted ⚠",
                  icon: CupertinoIcons.info,
                  color: AppColors.orangeColor,
                ),
              );
          }

          if (state is AssignmentError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                customSnackbar(
                  errorMsg: state.message,
                  icon: CupertinoIcons.info,
                  color: Colors.red.shade900,
                ),
              );
          }
          if (state is AssignmentLoaded) {
            const CircularProgressIndicator(color: AppColors.primaryColor);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            scrolledUnderElevation: 0,
            elevation: 0,
            title: Text('Assignments', style: AppStyle.font22BlackW500),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                CupertinoIcons.chevron_back,
                color: AppColors.blackColor,
                size: 26.sp,
              ),
            ),
          ),

          body: BlocBuilder<AssignmentCubit, AssignmentState>(
            builder: (context, state) {
              if (state is AssignmentLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (state is AssignmentUploading) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Uploading..."),
                    ],
                  ),
                );
              }

              if (state is AssignmentError) {
                return Center(child: Text(state.message));
              }

              if (state is AssignmentLoaded) {
                final assignments = List.of(state.assignments);

                assignments.sort(
                  (a, b) =>
                      _parseDate(a.dueDate).compareTo(_parseDate(b.dueDate)),
                );

                if (assignments.isEmpty) {
                  return const Center(child: Text("No Assignments"));
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  child: Column(
                    children: [
                      Gap(20.h),

                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 160.h),
                          itemCount: assignments.length,
                          separatorBuilder: (_, __) => Gap(12.h),
                          itemBuilder: (context, index) {
                            final assignment = assignments[index];
                            final color = cardColors[index % cardColors.length];

                            final attachment = assignment.attachmentPath ?? "";

                            const submitted = false;

                            final status = getStatus(
                              assignment.dueDate,
                              submitted,
                            );

                            final statusColor = getStatusColor(status);

                            return Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 10.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(
                                            5.r,
                                          ),
                                        ),
                                      ),

                                      Gap(10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              assignment.title,
                                              style: AppStyle.font16BlackBold,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Gap(4.h),
                                            Text(
                                              assignment.description,
                                              style: AppStyle.font14GreyW400
                                                  .copyWith(
                                                    color: Colors.black54,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                          border: Border.all(
                                            color: statusColor.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Gap(8.h),

                                  InkWell(
                                    onTap: () => openFile(attachment),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.doc_text,
                                            color: color,
                                            size: 20.sp,
                                          ),
                                          Gap(8.w),
                                          Expanded(
                                            child: Text(
                                              attachment.isEmpty
                                                  ? "No attachment"
                                                  : fileName(attachment),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Gap(10.h),

                                  InkWell(
                                    onTap: () async {
                                      final filePath = await pickFile();

                                      if (!context.mounted) return;
                                      if (filePath == null) return;

                                      context
                                          .read<AssignmentCubit>()
                                          .uploadSolution(
                                            assignmentId: assignment.id
                                                .toString(),
                                            filePath: filePath,
                                          );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: color.withOpacity(0.4),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.cloud_upload,
                                            color: color,
                                            size: 18.sp,
                                          ),
                                          Gap(8.w),
                                          const Text('Upload Your Solution'),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Gap(8.h),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        assignment.teacherSubject,
                                        style: TextStyle(color: color),
                                      ),
                                      Text(
                                        "Due: ${assignment.dueDate}",
                                        style: const TextStyle(
                                          color: AppColors.redColor,
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
                );
              }

              return const SizedBox();
            },
          ),
=======
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
>>>>>>> aa255c4e198149f3f192b9c73d020e7d3c5707aa
        ),
      ),
    );
  }
}