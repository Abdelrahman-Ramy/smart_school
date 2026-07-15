import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/teacher/cubit/attendance_cubit.dart';
import 'package:smart_school/features/teacher/cubit/attendance_state.dart';

class ClassTodayAttendanceView extends StatefulWidget {
  final int classId;

  const ClassTodayAttendanceView({super.key, required this.classId});

  @override
  State<ClassTodayAttendanceView> createState() =>
      _ClassTodayAttendanceViewState();
}

class _ClassTodayAttendanceViewState extends State<ClassTodayAttendanceView> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;

    _loaded = true;

    final cubit = context.read<AttendanceCubit>();
    cubit.loadTodayClassAttendance(widget.classId);
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

      body: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodayAttendanceLoaded) {
            final response = state.response;
            final data = response.data;

            if (data.isEmpty) {
              return const Center(child: Text("No attendance data today"));
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${response.date}",
                        style: AppStyle.font16BlackBold,
                      ),
                      Text(
                        "Count: ${response.count}",
                        style: AppStyle.font16BlackBold,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final isPresent = item.status == "present";

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: AppColors.primaryColor),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.studentName,
                                    style: AppStyle.font16BlackBold,
                                  ),
                                  Text(
                                    "ID: ${item.studentId}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: isPresent
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                isPresent ? "Present" : "Absent",
                                style: TextStyle(
                                  color: isPresent ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is AttendanceError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
