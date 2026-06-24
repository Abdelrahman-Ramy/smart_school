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
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/data/user_model.dart';

class StudentSettingsView extends StatefulWidget {
  const StudentSettingsView({super.key});

  @override
  State<StudentSettingsView> createState() => _StudentSettingsViewState();
}

class _StudentSettingsViewState extends State<StudentSettingsView> {
  bool isNotificationsEnabled = true;
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;
  // logout
  Future<void> logout() async {
    try {
      await authRepo.logout();

      if (context.mounted) {
        context.pushNamedAndRemoveUntil(
          Routes.loginScreen,
          predicate: (Route<dynamic> route) {
            return false;
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // get user data
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
                    Gap(8.w),
                    Icon(Icons.person, size: 50.sp, color: AppColors.glassyColor),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userModel == null
                            ? const Center(
                              child: CupertinoActivityIndicator(
                                  color: AppColors.whiteColor,
                                ),
                            )
                            : Text(
                                userModel?.name.toString() ?? "name",
                                style: AppStyle.font20BlackW500.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                        Gap(5.h),
                        userModel == null
                            ? const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : Text(
                                userModel?.email.toString() ??
                                    "example@email.com",
                                style: AppStyle.font13White500.copyWith(
                                  fontSize: 12.sp,
                                ),
                              ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 80.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.glassyColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
      
                      child: Center(
                        child: Text(
                          'ID:  ${userModel?.id.toString() ?? "00"}',
                          style: AppStyle.font14WhiteBold.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Gap(8.w),
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
                onTap: () {
                  context.pushNamed(Routes.changePass);
                },
              ),
              // SettingsItem(
              //   icon: Icons.notifications_none_outlined,
              //   title: 'Notifications',
              //   trailing: Switch(
              //     value: isNotificationsEnabled,
              //     onChanged: (val) {
              //       setState(() {
              //         isNotificationsEnabled = val;
              //       });
              //     },
              //     activeColor: Colors.white,
              //     activeTrackColor: AppColors.greenDarkColor,
              //   ),
              // ),
              // SettingsItem(
              //   icon: CupertinoIcons.globe,
              //   title: 'Language',
              //   trailing: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Text('English', style: AppStyle.font15GreyW400),
              //       SizedBox(width: 8.w),
              //       Icon(
              //         Icons.arrow_forward_ios,
              //         size: 16.sp,
              //         color: AppColors.greyColor,
              //       ),
              //     ],
              //   ),
              // ),
              Gap(250.h),
              AppTextButton(
                buttonText: 'Log Out',
                backgroundColor: AppColors.redColor,
                textStyle: AppStyle.font22BlackW500.copyWith(
                  color: AppColors.whiteColor,
                ),
                onPressed: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
