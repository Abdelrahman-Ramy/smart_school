import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/settings_item.dart';

class StudentSettingsView extends StatefulWidget {
  const StudentSettingsView({super.key});

  @override
  State<StudentSettingsView> createState() => _StudentSettingsViewState();
}

class _StudentSettingsViewState extends State<StudentSettingsView> {
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Colors.transparent),
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: Text('Settings', style: AppStyle.font22BlackW500),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Gap(15.h),
            Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Gap(12.w),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.asset(width: 65.w, 'assets/images/.jpg'),
                  ),
                  Gap(20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Omar Ahmed',
                        style: AppStyle.font20BlackW500.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      Gap(5.h),
                      Text('ID: 42022101', style: AppStyle.font13White500),
                    ],
                  ),
                  Gap(35.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(80.h, 30.w),
                      backgroundColor: AppColors.glassyColor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: AppStyle.font14WhiteBold.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(30.h),
            SettingsItem(
              icon: CupertinoIcons.person,
              title: 'Account',
              subtitle: 'Show profile details',
              onTap: () => context.pushNamed(Routes.studentProfile),
            ),
            SettingsItem(
              icon: CupertinoIcons.lock,
              title: 'Change Password',
              onTap: () {},
            ),
            SettingsItem(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              trailing: Switch(
                value: isNotificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    isNotificationsEnabled = val;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: AppColors.greenDarkColor,
              ),
            ),
            SettingsItem(
              icon: CupertinoIcons.globe,
              title: 'Language',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('English', style: AppStyle.font15GreyW400),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),
            Gap(130.h),
            AppTextButton(
              buttonText: 'Log Out',
              backgroundColor: AppColors.redColor,
              textStyle: AppStyle.font22BlackW500.copyWith(
                color: AppColors.whiteColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
