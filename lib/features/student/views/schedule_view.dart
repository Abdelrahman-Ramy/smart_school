import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/cubits/schedule_cubit.dart';
import 'package:smart_school/features/student/cubits/schedule_state.dart';
import 'package:smart_school/features/student/data/student_schedule_model.dart';
import 'package:smart_school/features/student/widgets/build_days_selector.dart';
import 'package:smart_school/features/student/widgets/lesson_card.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final List<String> days = [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri'
  ];

  late ScheduleCubit cubit;

  String selectedDay = 'Sat';

  @override
  void initState() {
    super.initState();

    cubit = ScheduleCubit(StudentRepo());
    cubit.getSchedule();
  }

  // =========================
  // NORMALIZE DAY
  // =========================
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Schedule', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),

      body: Column(
        children: [
          Gap(20.h),

          BuildDaysSelector(
            onDaySelected: (day) {
              cubit.changeDay(day);
            },
          ),

          Gap(10.h),

          Expanded(
            child: BlocBuilder<ScheduleCubit, ScheduleState>(
              bloc: cubit,
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

                  if (lessons.isEmpty) {
                    return const Center(child: Text('No schedule found'));
                  }

                  // =========================
                  // FILTER FIX (CLEAN & STABLE)
                  // =========================
                  final filtered = lessons.where((lesson) {
                    final apiDay = normalizeDay(lesson.day);
                    return apiDay.toLowerCase() ==
                        selectedDay.toLowerCase();
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No lessons for this day'),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 160.h),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => Gap(12.h),
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
    );
  }
}