import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/views/assignments_view.dart';
import 'package:smart_school/features/student/widgets/custom_stu_con.dart';

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
                  const Icon(
                    Icons.notifications_active,
                    color: AppColors.primaryColor,
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
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.3,
                shrinkWrap: true,
                children: [
                  CustomStuCon(
                    text: 'Assignments',
                    icon: Icons.description_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AssignmentsView(),
                        ),
                      );
                    },
                  ),
                  CustomStuCon(
                    text: 'Quizzes',
                    icon: Icons.access_time,
                    onTap: () {},
                  ),
                  CustomStuCon(
                    text: 'Grades',
                    icon: Icons.list_alt,
                    onTap: () {},
                  ),
                  CustomStuCon(
                    text: 'Attendance',
                    icon: Icons.people_outline,
                    onTap: () {},
                  ),
                  CustomStuCon(
                    text: 'Schedule',
                    icon: Icons.calendar_today_outlined,
                    onTap: () {},
                  ),
                  CustomStuCon(
                    text: 'SmartBot',
                    icon: Icons.smart_toy_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> menuItems = [
  {'title': 'Assignments', 'icon': CupertinoIcons.doc_text_fill},
  {'title': 'Quizzes', 'icon': CupertinoIcons.clock_fill},
  {'title': 'Grades', 'icon': CupertinoIcons.list_bullet},
  {'title': 'Attendance', 'icon': CupertinoIcons.group_solid},
  {'title': 'Schedule', 'icon': CupertinoIcons.calendar_today},
  {'title': 'SmartBot', 'icon': CupertinoIcons.ant_fill},
];
