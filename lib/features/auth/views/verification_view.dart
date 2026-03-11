import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/features/auth/views/reset_pass_view.dart';

class VerificationView extends StatelessWidget {
  VerificationView({super.key});
  final TextEditingController codeController = TextEditingController();
  final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(50.h),
              Text(
                'Enter Verification code',
                style: AppStyle.font18GreyW500.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              Gap(40.h),
              Pinput(
                controller: codeController,
                separatorBuilder: (index) => Gap(12.w),
                length: 4,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onCompleted: (pin) {
                  if (pin != "1234") {
                    codeController.clear();
                  }
                },
              ),
              Gap(50.h),
              AppTextButton(
                buttonText: 'Continue',
                textStyle: AppStyle.font14WhiteBold,
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPassView()),
                  );
                },
              ),
              Gap(25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'If you didn’t receive a code,',
                    style: AppStyle.font13White500.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      ' Resend',
                      style: AppStyle.font13White500.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
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
