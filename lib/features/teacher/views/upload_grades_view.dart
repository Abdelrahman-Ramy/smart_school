import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/widgets/custom_info_banner.dart';
import 'package:smart_school/features/teacher/widgets/exam_header_fields.dart';
import 'package:smart_school/features/teacher/widgets/student_grade_row.dart';

import 'package:smart_school/features/teacher/cubit/upload_grades_cubit.dart';
import 'package:smart_school/features/teacher/cubit/upload_grades_state.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';

class UploadGradesView extends StatefulWidget {
  final String classId;
  final List<dynamic> students;

  const UploadGradesView({
    super.key,
    required this.classId,
    required this.students,
  });

  @override
  State<UploadGradesView> createState() => _UploadGradesViewState();
}

class _UploadGradesViewState extends State<UploadGradesView> {
  late UploadGradesCubit cubit;

  final TextEditingController totalMarksController = TextEditingController(
    text: '10',
  );

  final TextEditingController examNameController = TextEditingController(
    text: 'Quiz 1',
  );

  final Map<String, TextEditingController> _scoreControllers = {};

  bool isUploading = false;
  bool isLoadingStudents = false;

  List<dynamic> fetchedStudents = [];

  @override
  void initState() {
    super.initState();
    cubit = UploadGradesCubit(TeacherRepo());
    _loadStudents();
  }

  // =========================
  // INIT CONTROLLERS (FIXED)
  // =========================
  void _initControllers(List<dynamic> students) {
    for (var student in students) {
      final String studentId = student['student_id'].toString();

      _scoreControllers.putIfAbsent(
        studentId,
        () => TextEditingController(text: '0'),
      );
    }
  }

  // =========================
  // LOAD STUDENTS
  // =========================
  Future<void> _loadStudents() async {
    if (widget.students.isNotEmpty) {
      fetchedStudents = widget.students;
      _initControllers(fetchedStudents);

      setState(() {});
      return;
    }

    setState(() => isLoadingStudents = true);

    try {
      final response = await TeacherRepo().apiService.get(
        '/teacher/classes/${widget.classId}/students',
      );

      final List<dynamic> students = response['data']?['students'] ?? [];

      fetchedStudents = students;

      _initControllers(students);

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => isLoadingStudents = false);
    }
  }

  // =========================
  // FIXED: COLLECT SCORES
  // =========================
  Map<String, String> _collectScores() {
    final map = <String, String>{};

    for (final student in fetchedStudents) {
      final String studentId = student['student_id'].toString();

      map[studentId] = _scoreControllers[studentId]?.text.trim() ?? '0';
    }

    return map;
  }

  // =========================
  // SEND NOTIFICATIONS
  // =========================
  Future<void> _sendNotifications() async {
    for (final student in fetchedStudents) {
      final studentId = student['student_id'].toString();

      await TeacherRepo().createNotification(
        receiverId: studentId,
        senderId: "teacher_id_here",
        senderName: "Teacher",
        title: "New Grades Uploaded",
        body: "Your quiz results have been published",
        type: "grade",
        relatedId: "",
      );
    }

    print("NOTIFICATIONS SENT");
  }

  // =========================
  // UPLOAD
  // =========================
  Future<void> _uploadQuizAndGrades() async {
    if (examNameController.text.trim().isEmpty ||
        totalMarksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Please fill grade details',
          icon: Icons.info,
          color: AppColors.greyColor,
        ),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      await cubit.uploadGrades(
        title: examNameController.text.trim(),
        maxScore: totalMarksController.text.trim(),
        scores: _collectScores(),
      );

      final state = cubit.state;

      if (state is UploadGradesSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: state.message,
            icon: Icons.check,
            color: Colors.green.shade900,
          ),
        );

        await _sendNotifications();

        Navigator.of(context).pop(true);
      }

      if (state is UploadGradesFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: state.error,
            icon: CupertinoIcons.info,
            color: Colors.red.shade900,
          ),
        );
      }
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  void dispose() {
    totalMarksController.dispose();
    examNameController.dispose();

    for (var c in _scoreControllers.values) {
      c.dispose();
    }

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

        body: isUploading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExamHeaderFields(
                      totalMarksController: totalMarksController,
                      totalMarksNameController: examNameController,
                    ),
                    Gap(20.h),

                    const CustomInfoBanner(
                      text: 'Enter the scores for each student below.',
                    ),

                    isLoadingStudents
                        ? const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : fetchedStudents.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: Text('No students found')),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: fetchedStudents.length,
                            itemBuilder: (context, index) {
                              final student = fetchedStudents[index];

                              final String studentId = student['student_id']
                                  .toString();

                              final String name = student is Map
                                  ? (student['student_name'] ??
                                        student['name'] ??
                                        'Unknown')
                                  : (student.studentName ??
                                        student.name ??
                                        'Unknown');

                              return StudentGradeRow(
                                name: name,
                                rollNo: '${index + 1}',
                                totalMarks: totalMarksController.text,
                                controller: _scoreControllers[studentId],
                              );
                            },
                          ),
                  ],
                ),
              ),

        bottomSheet: isUploading || isLoadingStudents
            ? const SizedBox()
            : Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade800, blurRadius: 15),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 23.h,
                  ),
                  child: AppTextButton(
                    buttonText: 'Upload Grades',
                    backgroundColor: AppColors.primaryColor,
                    textStyle: AppStyle.font18WhiteW500.copyWith(
                      fontWeight: FontWeight.bold,
                    ),

                    onPressed: _uploadQuizAndGrades,
                  ),
                ),
              ),
      ),
    );
  }
}
