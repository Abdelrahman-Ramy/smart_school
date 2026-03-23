import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/features/auth/views/forget_pass_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Gap(50.h),
                    Center(
                      child: Image.asset(
                        width: 350.w,
                        'assets/images/logo_splash.png',
                      ),
                    ),
                    Gap(50.h),
                    Container(
                      width: double.infinity,
                      height: 390.h,
                      decoration: BoxDecoration(
                        color: AppColors.glassyColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Gap(20.h),
                              AppTextFormField(
                                hintText: 'Email Address',
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                              Gap(12.h),
                              AppTextFormField(
                                hintText: 'Password',
                                controller: passwordController,
                                textInputAction: TextInputAction.done,
                                isObscureText: isObscureText,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isObscureText = !isObscureText;
                                    });
                                  },
                                  child: Icon(
                                    color: AppColors.primaryColor,
                                    isObscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              Gap(15.h),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgetPassView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forget Password?',
                                  style: AppStyle.font15GreyW400.copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Gap(30.h),
                              AppTextButton(
                                buttonText: 'Login',
                                isNav: false,
                                textStyle: AppStyle.font14WhiteBold,
                                backgroundColor: AppColors.primaryColor,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {}
                                },
                              ),
                              Gap(60.h),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Haven't any account? ",
                                        style: AppStyle.font15GreyW400.copyWith(
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Create account.',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.pushNamed(Routes.register);
                                          },
                                        style: AppStyle.font15GreyW400.copyWith(
                                          color: AppColors.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
