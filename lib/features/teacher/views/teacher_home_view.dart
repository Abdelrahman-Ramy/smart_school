import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/data/user_model.dart';
import 'package:smart_school/features/notifications/widgets/notification_badge_icon.dart';
import 'package:smart_school/features/student/widgets/custom_stu_con.dart';
import 'package:smart_school/features/teacher/data/teacher_class_model.dart';

class TeacherHomeView extends StatefulWidget {
  const TeacherHomeView({super.key});

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  AuthRepo authRepo = AuthRepo();
  TeacherClassModel teacherClassModel = TeacherClassModel();

  UserModel? userModel;

  Future<void> fetchUserData() async {
    try {
      final user = await authRepo.getProfile();

      if (mounted) {
        setState(() {
          userModel = user;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                    NotificationBadgeIcon(
                      icon: Icons.notifications_active,
                      iconColor: AppColors.primaryColor,
                      onTap: () {
                        context.pushNamed(Routes.teacherNotifications);
                      },
                    ),
                  ],
                ),
                Gap(20.h),
                Text(
                  'Welcome Mr, ${userModel?.name?.toString() ?? 'name'}',
                  style: AppStyle.font25BlackBold,
                ),
                Gap(10.h),
                Text(
                  'Tap on the view classes to see your classes and manage your students.',
                  style: AppStyle.font15BlackBold.copyWith(
                    color: AppColors.tealColor,
                  ),
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
                      CustomStuCon(
                        text: 'View Classes',
                        icon: Icons.grid_view,
                        onTap: () {
                          context.pushNamed(Routes.teacherViewClasses);
                        },
                      ),
                      CustomStuCon(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        text: 'Upload Attendance',
                        icon: Icons.how_to_reg,
                        onTap: () {
                          // context.pushNamed(Routes.teacherUploadAttendance);
                        },
                      ),
                      CustomStuCon(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        text: 'Upload Grades',
                        icon: Icons.leaderboard,
                        onTap: () {
                          // context.pushNamed(Routes.teacherUploadGrades);
                        },
                      ),
                      CustomStuCon(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        text: 'Upload Tasks',
                        icon: Icons.task_alt,
                        onTap: () {
                          // context.pushNamed(
                          //   Routes.teacherUploadTasks,
                          //   arguments: teacherClassModel.classId.toString(),
                          // );
                        },
                      ),
                      CustomStuCon(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        text: 'Upload Materials',
                        icon: Icons.cloud_upload,
                        onTap: () {
                          // Navigator.of(context).pushNamed(
                          //   Routes.teacherUploadMaterials,
                          //   arguments: teacherClassModel.classId.toString(),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
