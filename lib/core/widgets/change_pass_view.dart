import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/data/change_password_model.dart';

class ChangePassView extends StatefulWidget {
  const ChangePassView({super.key});

  @override
  State<ChangePassView> createState() => _ChangePassViewState();
}

class _ChangePassViewState extends State<ChangePassView> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isCurrentPasswordObscure = true;
  bool isNewPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  // forget password pin theme
  AuthRepo authRepo = AuthRepo();
  ChangePasswordModel? changePasswordModel;
  Future<void> changePassword() async {
    try {
      final response = await authRepo.changePassword(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      setState(() {
        changePasswordModel = response;
      });

      if (response != null && response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: 'Password changed successfully',
            icon: Icons.check,
            color: Colors.green.shade900,
          ),
        );
        Navigator.of(context).pop(); // Close the Change Password screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: response?.message ?? 'Failed to change password',
            icon: CupertinoIcons.info,
            color: Colors.red.shade900,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(
          errorMsg: e.toString(),
          icon: CupertinoIcons.info,
          color: Colors.red.shade900,
        ),
      );
    }
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(30.h),
                Center(
                  child: Text(
                    'Change Password',
                    style: AppStyle.font22BlackW500,
                  ),
                ),
                Gap(50.h),
                Text(
                  ' Enter Current Password',
                  style: AppStyle.font15BlackBold,
                ),
                Gap(8.h),
                AppTextFormField(
                  hintText: 'Current Password',
                  textInputAction: TextInputAction.next,
                  controller: currentPasswordController,
                  isObscureText: isCurrentPasswordObscure,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isCurrentPasswordObscure = !isCurrentPasswordObscure;
                      });
                    },
                    child: Icon(
                      color: AppColors.primaryColor,
                      isCurrentPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.3,
                    ),
                  ),
                ),
                Gap(20.h),
                Text(' Enter New Password', style: AppStyle.font15BlackBold),
                Gap(8.h),
                AppTextFormField(
                  hintText: 'New Password',
                  textInputAction: TextInputAction.next,
                  controller: newPasswordController,
                  isObscureText: isNewPasswordObscure,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isNewPasswordObscure = !isNewPasswordObscure;
                      });
                    },
                    child: Icon(
                      color: AppColors.primaryColor,
                      isNewPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.3,
                    ),
                  ),
                ),
                Gap(20.h),
                Text(
                  ' Enter Confirm Password',
                  style: AppStyle.font15BlackBold,
                ),
                Gap(8.h),
                AppTextFormField(
                  hintText: 'Confirm Password',
                  textInputAction: TextInputAction.done,
                  controller: confirmPasswordController,
                  isObscureText: isConfirmPasswordObscure,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isConfirmPasswordObscure = !isConfirmPasswordObscure;
                      });
                    },
                    child: Icon(
                      color: AppColors.primaryColor,
                      isConfirmPasswordObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.3,
                    ),
                  ),
                ),
                Gap(50.h),
                AppTextButton(
                  buttonText: 'Done',
                  textStyle: AppStyle.font18WhiteW500,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () async {
                    if (newPasswordController.text.trim() !=
                        confirmPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackbar(
                          errorMsg: 'Passwords do not match',
                          icon: CupertinoIcons.info,
                          color: Colors.red.shade900,
                        ),
                      );
                      return;
                    }

                    await changePassword();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
