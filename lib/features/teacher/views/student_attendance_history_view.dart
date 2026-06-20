import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';

class StudentAttendanceHistoryView extends StatefulWidget {
  final int studentId;

  const StudentAttendanceHistoryView({super.key, required this.studentId});

  @override
  State<StudentAttendanceHistoryView> createState() =>
      _StudentAttendanceHistoryViewState();
}

class _StudentAttendanceHistoryViewState
    extends State<StudentAttendanceHistoryView> {
  bool isLoading = true;
  List<dynamic> historyList = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final repo = TeacherRepo();
      final response = await repo.getStudentAttendanceHistory(
        studentId: widget.studentId,
      );
      setState(() {
        historyList = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Attendance History', style: AppStyle.font22BlackW500),
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
          ? const Center(child: CircularProgressIndicator())
          : historyList.isEmpty
          ? const Center(child: Text('No history found for this student'))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];
                bool isPresent = item.status == 'present';
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 20.sp,
                        color: AppColors.greyColor,
                      ),
                      Gap(12.w),
                      Text(
                        item.date.toString(),
                        style: AppStyle.font16BlackBold,
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isPresent ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          isPresent ? 'Present' : 'Absent',
                          style: TextStyle(
                            color: isPresent
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
