import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

import 'package:smart_school/features/student/cubits/grade_cubit.dart';
import 'package:smart_school/features/student/cubits/grade_state.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

import 'package:smart_school/features/student/widgets/grade_card.dart';
import 'package:smart_school/features/student/widgets/summary_bar.dart';

class GradesView extends StatefulWidget {
  const GradesView({super.key});

  static const List<Map<String, dynamic>> _dummyGrades = [
    {
      'colorSubject': AppColors.greenLightColor,
      'isDone': true,
      'title': 'English',
      'subtitle': 'Chapter 1-5',
      'mark': 95,
      'grade': 'A+',
      'date': '13/12/2025',
      'time': '10:30 AM - 11:30 AM',
    },
    {
      'colorSubject': Colors.blue,
      'isDone': true,
      'title': 'Mathematics',
      'subtitle': 'Algebra & Geometry',
      'mark': 85,
      'grade': 'A',
      'date': '14/12/2025',
      'time': '09:00 AM - 10:30 AM',
    },
    {
      'colorSubject': Colors.purple,
      'isDone': true,
      'title': 'Science',
      'subtitle': 'Physics Quiz',
      'mark': 78,
      'grade': 'B+',
      'date': '15/12/2025',
      'time': '11:00 AM - 12:00 PM',
    },
    {
      'colorSubject': Colors.orange,
      'isDone': true,
      'title': 'Arabic',
      'subtitle': 'Grammar Exam',
      'mark': 99,
      'grade': 'A+',
      'date': '16/12/2025',
      'time': '08:30 AM - 10:00 AM',
    },
    {
      'colorSubject': Colors.red,
      'isDone': true,
      'title': 'History',
      'subtitle': 'Modern Era',
      'mark': 62,
      'grade': 'C',
      'date': '17/12/2025',
      'time': '12:30 PM - 01:30 PM',
    },
  ];

  @override
  State<GradesView> createState() => _GradesViewState();
}

class _GradesViewState extends State<GradesView> {
  late GradesCubit cubit;

  final List<Color> colors = [
    AppColors.blueLightColor,
    AppColors.greenLightColor,
    AppColors.orangeColor,
    AppColors.purpleColor,
    AppColors.tealColor,
    AppColors.redColor,
  ];

  @override
  void initState() {
    super.initState();
    cubit = GradesCubit(StudentRepo());
    cubit.getGrades();
  }

  String getLetterGrade(int percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Grades', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.blackColor,
            size: 26.sp,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: Column(
            children: [
              Gap(20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Last Revision Exam', style: AppStyle.font19BlackW500),
                  Text('Student Results', style: AppStyle.font15GreyW400),
                ],
              ),

              Gap(15.h),

              Expanded(
                child: BlocBuilder<GradesCubit, GradeState>(
                  bloc: cubit,
                  builder: (context, state) {
                    if (state is GradeLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    if (state is GradeError) {
                      return Center(child: Text(state.error));
                    }

                    if (state is GradeLoaded) {
                      if (state.grades.isEmpty) {
                        return const Center(child: Text('No grades found'));
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: 160.h),
                        itemCount: state.grades.length,
                        separatorBuilder: (_, _) => Gap(12.h),
                        itemBuilder: (context, index) {
                          final grade = state.grades[index];

                          return GradeCard(
                            colorSubject: colors[index % colors.length],

                            isDone: true,

                            title: grade.title,

                            subtitle: '${grade.score}/${grade.maxScore}',

                            mark: grade.percentage,

                            grade: getLetterGrade(grade.percentage),

                            date: '',

                            time: '',
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
      ),

      // bottomSheet: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      //   height: 100.h,
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(30),
      //       topRight: Radius.circular(30),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         offset: const Offset(0, -3),
      //       ),
      //     ],
      //   ),
      //   child: const SummaryBar(),
      // ),
    );
  }
}
