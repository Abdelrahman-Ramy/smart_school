import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/features/auth/views/login_view.dart';
import 'package:smart_school/features/auth/widgets/custom_selected_type.dart';
import 'package:smart_school/features/parent/views/parent_home_view.dart';
import 'package:smart_school/features/student/views/student_home_view.dart';
import 'package:smart_school/features/teacher/views/teacher_home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedType = 'Student';
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
              child: Column(
                children: [
                  Gap(25.h),
                  Center(
                    child: Image.asset(
                      width: 350.w,
                      'assets/images/logo_splash.png',
                    ),
                  ),
                  Gap(30.h),
                  Container(
                    width: double.infinity,
                    height: 515.h,
                    decoration: BoxDecoration(
                      color: AppColors.glassyColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Gap(20.h),
                          AppTextFormField(
                            hintText: 'Name',
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                          ),
                          Gap(20.h),
                          AppTextFormField(
                            hintText: 'Email',
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                          ),
                          Gap(20.h),
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
                          Gap(20.h),
                          AppTextFormField(
                            hintText: 'Phone Number',
                            controller: emailController,
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
                              if (selectedType == "Parent") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ParentHomeView(),
                                  ),
                                );
                              } else if (selectedType == "Student") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const StudentHomeView(),
                                  ),
                                );
                              } else if (selectedType == "Teacher") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TeacherHomeView(),
                                  ),
                                );
                              }
                            },
                          ),
                          Gap(15.h),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
