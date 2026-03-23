import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/features/auth/views/login_view.dart';
import 'package:smart_school/features/auth/widgets/custom_selected_type.dart';
import 'package:smart_school/features/parent/views/parent_home_view.dart';
import 'package:smart_school/features/student/views/student_root.dart';
import 'package:smart_school/features/teacher/views/teacher_home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedType = 'Student';
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();

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
                    Center(
                      child: Image.asset(
                        width: 310.w,
                        'assets/images/logo_splash.png',
                      ),
                    ),
                    Gap(20.h),
                    Container(
                      width: double.infinity,
                      height: 590.h,
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
                              Gap(15.h),
                              AppTextFormField(
                                hintText: 'Your Name',
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                              ),
                              Gap(10.h),
                              AppTextFormField(
                                hintText: 'Email Address',
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                              ),
                              Gap(10.h),
                              AppTextFormField(
                                hintText: 'Password',
                                controller: passwordController,
                                textInputAction: TextInputAction.next,
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
                              Gap(10.h),
                              if (selectedType == 'Student')
                                AppTextFormField(
                                  hintText: 'Student ID',
                                  controller: idController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                )
                              else
                                AppTextFormField(
                                  hintText: 'Enter Phone Number',
                                  controller: phoneController,
                                  isPhone: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  textInputAction: TextInputAction.next,
                                ),
                              Gap(10.h),
                              if (selectedType == 'Student')
                                AppTextFormField(
                                  hintText: "One of your parents phone",
                                  controller: phoneController,
                                  isPhone: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  textInputAction: TextInputAction.next,
                                ),
                                Gap(10.h),
                              AppTextFormField(
                                hintText: 'Your Address',
                                controller: addressController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                              ),
                              Gap(5.h),
                              Row(
                                children: [
                                  CustomSelectedType(
                                    typeUser: 'Student',
                                    onChanged: (value) =>
                                        setState(() => selectedType = value),
                                    selectedType: selectedType,
                                  ),
                                  CustomSelectedType(
                                    typeUser: 'Parent',
                                    onChanged: (value) =>
                                        setState(() => selectedType = value),
                                    selectedType: selectedType,
                                  ),
                                  CustomSelectedType(
                                    typeUser: 'Teacher',
                                    onChanged: (value) =>
                                        setState(() => selectedType = value),
                                    selectedType: selectedType,
                                  ),
                                ],
                              ),
                              Gap(10.h),
                              AppTextButton(
                                buttonText: 'Sign Up',
                                isNav: false,
                                textStyle: AppStyle.font14WhiteBold,
                                backgroundColor: AppColors.primaryColor,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (selectedType == "Parent") {
                                      context.pushNamed(Routes.parentRoot);
                                    } else if (selectedType == "Student") {
                                      context.pushNamed(Routes.studentRoot);
                                    } else if (selectedType == "Teacher") {
                                      context.pushNamed(Routes.teacherRoot);
                                    }
                                  }
                                },
                              ),
                              Gap(10.h),
                              AppTextButton(
                                buttonText: 'Go To Login',
                                isNav: true,
                                textStyle: AppStyle.font14WhiteBold.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                                backgroundColor: AppColors.whiteColor,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                  );
                                },
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
