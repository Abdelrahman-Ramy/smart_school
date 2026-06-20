import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/widgets/custom_info_banner.dart';
import 'package:smart_school/features/teacher/widgets/exam_header_fields.dart';
import 'package:smart_school/features/teacher/widgets/student_grade_row.dart';
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
  bool isUploading = false;
  bool isLoadingStudents = false;
  List<dynamic> fetchedStudents = [];

  final TextEditingController totalMarksController = TextEditingController(
    text: '10',
  );
  final TextEditingController examNameController = TextEditingController(
    text: 'Quiz 1',
  );

  final Map<int, TextEditingController> _scoreControllers = {};
  final _repo = TeacherRepo();

  @override
  void initState() {
    super.initState();
    _loadStudentsData();
  }

  Future<void> _loadStudentsData() async {
    if (widget.students.isNotEmpty) {
      setState(() {
        fetchedStudents = widget.students;
      });
      _initControllers(widget.students);
      return;
    }

    setState(() => isLoadingStudents = true);
    try {
      final response = await _repo.apiService.get(
        '/teacher/attendance/class/today/${widget.classId}',
      );

      if (response is Map<String, dynamic> && response['data'] != null) {
        final data = response['data'];
        List<dynamic> studentsList = [];

        if (data is Map<String, dynamic> && data['students'] != null) {
          studentsList = data['students'];
        } else if (data is Map<String, dynamic> && data['records'] != null) {
          studentsList = data['records'];
        } else if (data is List) {
          studentsList = data;
        }

        setState(() {
          fetchedStudents = studentsList;
        });
        _initControllers(studentsList);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Failed to load students: ${e.toString()}',
          icon: Icons.info,
          color: AppColors.greyColor,
        ),
      );
    } finally {
      setState(() => isLoadingStudents = false);
    }
  }

  void _initControllers(List<dynamic> students) {
    for (var student in students) {
      if (student != null) {
        final int? studentId = student is Map
            ? (student['id'] ?? student['student_id'])
            : (student.id ?? student.studentId);

        if (studentId != null) {
          _scoreControllers[studentId] = TextEditingController(text: '0');
        }
      }
    }
  }

  @override
  void dispose() {
    totalMarksController.dispose();
    examNameController.dispose();
    for (var controller in _scoreControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _uploadQuizAndGrades() async {
    if (examNameController.text.trim().isEmpty ||
        totalMarksController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: 'Please fill quiz details',
          icon: Icons.info,
          color: AppColors.greyColor,
        ),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final String todayDate =
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

      final quizRes = await _repo.addQuiz(
        classId: widget.classId,
        title: examNameController.text.trim(),
        description: examNameController.text.trim(),
        quizDate: todayDate,
        totalMarks: totalMarksController.text.trim(),
      );

      if (quizRes.success && quizRes.data != null) {
        final String quizId = quizRes.data!.id.toString();

        if (fetchedStudents.isNotEmpty) {
          for (var student in fetchedStudents) {
            if (student is Map) {
              final studentIdKeyId = student['id'];
              final studentIdKeyStudentId = student['student_id'];
              final studentIdKeyUserId = student['user_id'];
              final score =
                  _scoreControllers[studentIdKeyId ?? studentIdKeyStudentId]
                      ?.text
                      .trim() ??
                  '0';

              try {
                await _repo.saveStudentQuizResult(
                  quizId: quizId,
                  studentId: studentIdKeyStudentId ?? studentIdKeyId,
                  score: score,
                );
              } catch (_) {
                try {
                  await _repo.saveStudentQuizResult(
                    quizId: quizId,
                    studentId: studentIdKeyId ?? studentIdKeyStudentId,
                    score: score,
                  );
                } catch (_) {
                  try {
                    if (studentIdKeyUserId != null) {
                      await _repo.saveStudentQuizResult(
                        quizId: quizId,
                        studentId: studentIdKeyUserId,
                        score: score,
                      );
                    }
                  } catch (e) {
                    print(
                      "Failed to save quiz result for student ${student['name'] ?? 'Unknown'}: $e",
                    );
                  }
                }
              }
            }
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar(
              errorMsg: quizRes.message,
              icon: Icons.check,
              color: Colors.green.shade900,
            ),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: e.toString(),
            icon: Icons.info,
            color: AppColors.redColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isUploading = false);
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
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : fetchedStudents.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: const Center(
                              child: Text('No students found in this class'),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Colors.grey[100]!),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: fetchedStudents.length,
                              itemBuilder: (context, index) {
                                final student = fetchedStudents[index];

                                final String studentName = student is Map
                                    ? (student['student_name'] ??
                                          student['name'] ??
                                          'Unknown')
                                    : (student.studentName ??
                                          student.name ??
                                          'Unknown');

                                final int? studentId = student is Map
                                    ? (student['id'] ?? student['student_id'])
                                    : (student.id ?? student.studentId);

                                return StudentGradeRow(
                                  name: studentName,
                                  rollNo: '${index + 1}',
                                  totalMarks: totalMarksController.text,
                                  controller: _scoreControllers[studentId],
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
        bottomSheet: isUploading || isLoadingStudents
            ? const SizedBox.shrink()
            : Container(
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
