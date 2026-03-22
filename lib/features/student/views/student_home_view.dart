import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/custom_stu_card.dart';

class StudentHomeView extends StatelessWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),
              Row(
                children: [
                  Image.asset(width: 260.w, 'assets/images/logo_name.png'),
                  Gap(60.w),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.studentNotifications);
                    },
                    child: const Icon(
                      Icons.notifications_active,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              Gap(20.h),
              Text('  Good Morning,', style: AppStyle.font25BlackBold),
              Row(
                children: [
                  Text('  Kareem ', style: AppStyle.font25BlackBold),
                  const Icon(Icons.sunny, color: AppColors.yellowColor),
                ],
              ),
              Gap(30.h),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 1.2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CustomStuCard(
                      title: 'Assignments',
                      imagePath: 'assets/images/assignments.jpg',
                      onTap: () {
                        context.pushNamed(Routes.studentAssignments);
                      },
                    ),
                    CustomStuCard(
                      title: 'Quizzes',
                      imagePath: 'assets/images/quiz.jfif',
                      onTap: () {
                        context.pushNamed(Routes.studentQuizzes);
                      },
                    ),
                    CustomStuCard(
                      title: 'Grades',
                      imagePath: 'assets/images/grades.png',
                      onTap: () {
                        context.pushNamed(Routes.studentGrades);
                      },
                    ),
                    CustomStuCard(
                      title: 'Attendance',
                      imagePath: 'assets/images/attendance.jfif',
                      onTap: () {
                        context.pushNamed(Routes.studentAttendance);
                      },
                    ),
                    CustomStuCard(
                      title: 'Schedule',
                      imagePath: 'assets/images/schedule.png',
                      onTap: () {
                        context.pushNamed(Routes.studentSchedule);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// final List<Map<String, dynamic>> menuItems = [
//   {'title': 'Assignments', 'icon': CupertinoIcons.doc_text_fill},
//   {'title': 'Quizzes', 'icon': CupertinoIcons.clock_fill},
//   {'title': 'Grades', 'icon': CupertinoIcons.list_bullet},
//   {'title': 'Attendance', 'icon': CupertinoIcons.group_solid},
//   {'title': 'Schedule', 'icon': CupertinoIcons.calendar_today},
//   {'title': 'SmartBot', 'icon': CupertinoIcons.ant_fill},
// ];
