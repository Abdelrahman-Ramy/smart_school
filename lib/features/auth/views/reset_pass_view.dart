import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/features/auth/views/verification_view.dart';

class ResetPassView extends StatefulWidget {
  ResetPassView({super.key});

  @override
  State<ResetPassView> createState() => _ResetPassViewState();
}

class _ResetPassViewState extends State<ResetPassView> {
  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isObscureText1 = true;
  bool isObscureText2 = true;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(backgroundColor: AppColors.whiteColor),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(50.h),
              Center(
                child: Text(
                  'Reset Password',
                  style: AppStyle.font18GreyW500.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              Gap(40.h),
              Text(
                ' Enter New Password',
                style: AppStyle.font14WhiteBold.copyWith(color: AppColors.blackColor)
              ),
              Gap(8.h),
              AppTextFormField(
                hintText: 'New Password',
                controller: newPasswordController,
                isObscureText: isObscureText1,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscureText1 = !isObscureText1;
                    });
                  },
                  child: Icon(
                    color: AppColors.primaryColor,
                    isObscureText1 ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.3),
                ),
              ),
              Gap(20.h),
               Text(
                ' Enter Confirm Password',
                style: AppStyle.font14WhiteBold.copyWith(color: AppColors.blackColor)
              ),
              Gap(8.h),
              AppTextFormField(
                hintText: 'Confirm Password',
                controller: confirmPasswordController,
                isObscureText: isObscureText2,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscureText2 = !isObscureText2;
                    });
                  },
                  child: Icon(
                    color: AppColors.primaryColor,
                    isObscureText2 ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.3),
                ),
              ),
              Gap(50.h),
              AppTextButton(
                buttonText: 'Done',
                textStyle: AppStyle.font14WhiteBold,
                backgroundColor: AppColors.primaryColor,
                onPressed: () { },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
