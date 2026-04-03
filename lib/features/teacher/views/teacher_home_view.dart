import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/custom_stu_con.dart';

class TeacherHomeView extends StatelessWidget {
  const TeacherHomeView({super.key});

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
                      context.pushNamed(Routes.parentNotifications);
                    },
                    child: const Icon(
                      Icons.notifications_active,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              Gap(20.h),
              Text('  Welcome,', style: AppStyle.font25BlackBold),
              Text('  Mr: Mohamed ', style: AppStyle.font25BlackBold),
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
                    CustomStuCon(
                      text: 'View Classes',
                      icon: Icons.grid_view,
                      onTap: () {
                        context.pushNamed(Routes.teacherViewClasses);
                      },
                    ),
                    CustomStuCon(
                      text: 'Upload Attendance',
                      icon: Icons.how_to_reg,
                      onTap: () {
                        context.pushNamed(Routes.teacherUploadAttendance);
                      },
                    ),
                    CustomStuCon(
                      text: 'Upload Grades',
                      icon: Icons.leaderboard,
                      onTap: () {
                        context.pushNamed(Routes.teacherUploadGrades);
                      },
                    ),
                    CustomStuCon(
                      text: 'Upload Tasks',
                      icon: Icons.task_alt,
                      onTap: () {
                        context.pushNamed(Routes.teacherUploadTasks);
                      },
                    ),
                    CustomStuCon(
                      text: 'Upload Materials',
                      icon: Icons.cloud_upload,
                      onTap: () {
                        context.pushNamed(Routes.teacherUploadMaterials);
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
