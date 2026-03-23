import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}