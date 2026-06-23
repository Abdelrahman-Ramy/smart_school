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
import 'package:smart_school/features/teacher/views/class_today_attendance_view.dart';
import 'package:smart_school/features/teacher/widgets/attendance_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/teacher/cubit/attendance_cubit.dart';
import 'package:smart_school/features/teacher/cubit/attendance_state.dart';

class UploadAttendanceView extends StatefulWidget {
  final String classId;

  const UploadAttendanceView({super.key, required this.classId});

  @override
  State<UploadAttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<UploadAttendanceView> {
  int selectedFilter = 0;
  late final TeacherRepo repo;

  @override
  void initState() {
    super.initState();
    repo = TeacherRepo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AttendanceCubit(repo)..loadClassStudents(int.parse(widget.classId)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text('Attendance', style: AppStyle.font22BlackW500),

          actions: [
            IconButton(
              icon: const Icon(Icons.today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AttendanceCubit>(),
                      child: ClassTodayAttendanceView(
                        classId: int.parse(widget.classId),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              CupertinoIcons.chevron_back,
              color: AppColors.blackColor,
              size: 26.sp,
            ),
          ),
        ),

        body: BlocListener<AttendanceCubit, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackbar(
                  errorMsg: state.message,
                  icon: Icons.error_outline,
                  color: Colors.red.shade900,
                ),
              );
            }

            if (state is AttendanceSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackbar(
                  errorMsg: 'Attendance saved successfully',
                  icon: Icons.check,
                  color: Colors.green.shade900,
                ),
              );
            }
          },

          child: BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, state) {
              if (state is AttendanceLoading || state is AttendanceInitial) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (state is AttendanceLoaded) {
                final students = state.students;

                List<ClassAttendanceItem> visible;

                if (selectedFilter == 0) {
                  visible = students;
                } else if (selectedFilter == 1) {
                  visible = students
                      .where((s) => state.localStatus[s.studentId] == 'present')
                      .toList();
                } else {
                  visible = students
                      .where((s) => state.localStatus[s.studentId] == 'absent')
                      .toList();
                }

                return Column(
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
                            child: Text(
                              'Absent: ${state.localStatus.values.where((s) => s == 'absent').length}',
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(15.h),

                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final student = visible[index];
                          final current =
                              state.localStatus[student.studentId] ?? 'absent';

                          return AttendanceCard(
                            studentName: student.studentName,
                            currentStatus: current,
                            onStatusChanged: (_) {
                              context.read<AttendanceCubit>().toggleStatus(
                                student.studentId,
                              );
                            },
                            onViewHistoryTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.studentAttendanceHistory,
                                arguments: student.studentId,
                              );
                            },
                          );
                        },
                      ),
                    ),

                    Gap(50.h),
                  ],
                );
              }

              if (state is AttendanceError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox.shrink();
            },
          ),
        ),

        bottomSheet: Container(
          height: 180.h,
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 60.h),
          child: BlocBuilder<AttendanceCubit, AttendanceState>(
            builder: (context, state) {
              final saving = state is AttendanceSaving;

              return AppTextButton(
                buttonText: saving ? 'Saving...' : 'Save Attendance',
                backgroundColor: AppColors.primaryColor,
                textStyle: AppStyle.font18WhiteW500.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () {
                  if (saving) return;

                  context.read<AttendanceCubit>().saveAttendance(
                    int.parse(widget.classId),
                  );
                },
              );
            },
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
