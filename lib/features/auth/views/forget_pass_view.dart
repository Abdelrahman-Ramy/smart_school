import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/features/auth/views/verification_view.dart';

class ForgetPassView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  ForgetPassView({super.key});
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(50.h),
              Text(
                'Enter Email Address',
                style: AppStyle.font18GreyW500.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              Gap(40.h),
              AppTextFormField(
                hintText: 'Email',
                controller: emailController,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.3),
                ),
              ),
              Gap(50.h),
              AppTextButton(
                buttonText: 'Send Code',
                textStyle: AppStyle.font14WhiteBold,
                backgroundColor: AppColors.primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
