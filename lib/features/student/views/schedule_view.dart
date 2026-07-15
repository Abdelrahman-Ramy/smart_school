import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/cubits/schedule_cubit.dart';
import 'package:smart_school/features/student/cubits/schedule_state.dart';
import 'package:smart_school/features/student/widgets/build_days_selector.dart';
import 'package:smart_school/features/student/widgets/lesson_card.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  String normalizeDay(String day) {
    switch (day.toLowerCase().trim()) {
      case 'sunday':
        return 'Sun';
      case 'monday':
        return 'Mon';
      case 'tuesday':
        return 'Tue';
      case 'wednesday':
        return 'Wed';
      case 'thursday':
        return 'Thu';
      case 'friday':
        return 'Fri';
      case 'saturday':
        return 'Sat';
      default:
        return day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleCubit(StudentRepo())..getSchedule(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text('Schedule', style: AppStyle.font22BlackW500),
        ),
        body: Column(
          children: [
            Gap(20.h),

            /// ================= DAYS =================
            BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                return BuildDaysSelector(
                  onDaySelected: (day) {
                    context.read<ScheduleCubit>().changeDay(day);
                  },
                );
              },
            ),

            Gap(10.h),

            /// ================= LIST =================
            Expanded(
              child: BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (state is ScheduleError) {
                    return Center(child: Text(state.error));
                  }

                  if (state is ScheduleLoaded) {
                    final lessons = state.schedule;
                    final selectedDay = state.selectedDay;

                    final filtered = lessons.where((lesson) {
                      return normalizeDay(lesson.day).toLowerCase().trim() ==
                          selectedDay.toLowerCase().trim();
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text('No lessons for this day'),
                      );
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => Gap(12.h),
                      itemBuilder: (context, index) {
                        final lesson = filtered[index];

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: LessonCard(
                            lessonColor: AppColors.primaryColor,
                            lessonSubject: lesson.subject,
                            lessonTime:
                                '${lesson.startTime} - ${lesson.endTime}',
                            classroom: 'Class ${lesson.classId}',
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
