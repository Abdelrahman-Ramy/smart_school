import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/teacher/data/class_attendance_model.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/features/teacher/widgets/attendance_card.dart';

class UploadAttendanceView extends StatefulWidget {
  final String classId;

  const UploadAttendanceView({super.key, required this.classId});

  @override
  State<UploadAttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<UploadAttendanceView> {
  int selectedFilter = 0;
  bool isLoading = true;
  List<ClassAttendanceItem> allStudents = [];
  List<ClassAttendanceItem> filteredStudents = [];
  Map<int, String> localAttendanceStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchClassAttendance();
  }

  Future<void> _fetchClassAttendance() async {
    try {
      final repo = TeacherRepo();
      final response = await repo.getClassAttendanceToday(
        classId: int.parse(widget.classId),
      );

      if (response.success) {
        setState(() {
          allStudents = response.data;
          localAttendanceStatus.clear();
          for (var item in allStudents) {
            localAttendanceStatus[item.studentId] = item.status;
          }
          _applyFilter();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("خطأ أثناء جلب أو عمل parsing للبيانات: $e");
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      if (selectedFilter == 0) {
        filteredStudents = allStudents;
      } else if (selectedFilter == 1) {
        filteredStudents = allStudents
            .where((s) => localAttendanceStatus[s.studentId] == 'present')
            .toList();
      } else if (selectedFilter == 2) {
        filteredStudents = allStudents
            .where((s) => localAttendanceStatus[s.studentId] == 'absent')
            .toList();
      }
    });
  }

  int _getAbsentCount() {
    return localAttendanceStatus.values
        .where((status) => status == 'absent')
        .length;
  }



  Future<void> _saveAttendance() async {
    setState(() => isLoading = true);
    try {
      final repo = TeacherRepo();
      final List<Future> attendanceRequests = [];

      for (var studentId in localAttendanceStatus.keys) {
        attendanceRequests.add(
          repo.markStudentAttendance(
            studentId: studentId,
            classId: int.parse(widget.classId),
            status: localAttendanceStatus[studentId]!,
          ),
        );
      }

      await Future.wait(attendanceRequests);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Attendance saved successfully',
            icon: Icons.check,
            color: Colors.green.shade900,
          ),
        );
        _fetchClassAttendance();
      }
    } catch (e) {
      print("🚨 [Attendance Debug] تفاصيل الخطأ كاملة أثناء الحفظ:");
      print(e);

      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Failed to save attendance. Check terminal.',
            icon: Icons.error_outline,
            color: Colors.red.shade900,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Attendance', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.blackColor,
            size: 26.sp,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      buildFilterButton('All', 0),
                      Gap(5.w),
                      buildFilterButton('Present', 1),
                      Gap(5.w),
                      buildFilterButton('Absent', 2),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16.sp,
                              color: AppColors.greyColor,
                            ),
                            Gap(5.w),
                            Text(
                              'Absent: ${_getAbsentCount().toString().padLeft(2, '0')}',
                              style: AppStyle.font14GreyW400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(15.h),
                Expanded(
                  child: filteredStudents.isEmpty
                      ? const Center(child: Text('No students found'))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            return AttendanceCard(
                              studentName: student.studentName,
                              currentStatus:
                                  localAttendanceStatus[student.studentId] ??
                                  student.status,
                              onStatusChanged: (newStatus) {
                                setState(() {
                                  localAttendanceStatus[student.studentId] =
                                      newStatus;
                                  _applyFilter();
                                });
                              },
                              onViewHistoryTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.studentAttendanceHistory,
                                  arguments: student.studentId.toString(),
                                );
                              },
                            );
                          },
                        ),
                ),
                Gap(50.h),
              ],
            ),

      bottomSheet: Container(
        height: 180.h,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 60.h),
          child: AppTextButton(
            buttonText: 'Save Attendance',
            backgroundColor: AppColors.primaryColor,
            textStyle: AppStyle.font18WhiteW500.copyWith(
              fontWeight: FontWeight.bold,
            ),
            onPressed: _saveAttendance,
          ),
        ),
      ),
    );
  }

  Widget buildFilterButton(String label, int index) {
    bool isSelected = selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
          _applyFilter();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: isSelected
              ? AppStyle.font14WhiteBold
              : AppStyle.font14GreyW400,
        ),
      ),
    );
  }
}
