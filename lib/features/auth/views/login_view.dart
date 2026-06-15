import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/data/user_model.dart';
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
  bool isLoading = false;
  AuthRepo authRepo = AuthRepo();
  UserModel? userModel;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final user = await authRepo.login(
          emailController.text.trim(),

          passwordController.text.trim(),
        );

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackbar(
              errorMsg: 'Login Successfully',
              icon: Icons.check,
              color: Colors.green.shade900,
            ),
          );

          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.id.toString())
              .set({
                "id": user.id,
                "name": user.name,
                "email": user.email,
                "role": user.role,
              }, SetOptions(merge: true));
          await FirebaseFirestore.instance
              .collection("userChats")
              .doc(user.id.toString())
              .set({"chats": {}}, SetOptions(merge: true));
          // Navigate according to role

          if (user.role == 'teacher') {
            context.pushNamed(Routes.teacherRoot);
          } else if (user.role == 'student') {
            context.pushNamed(Routes.studentRoot);
          } else if (user.role == 'parent') {
            context.pushNamed(Routes.parentRoot);
          }
        }
      } catch (e) {
        String errorMsg = 'Unhandled Error in Login';

        if (e is ApiError) {
          errorMsg = e.message;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          customSnackbar(
            errorMsg: errorMsg,
            icon: CupertinoIcons.info,
            color: Colors.red.shade900,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

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
                  mainAxisAlignment: MainAxisAlignment.center,
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

                              // Login Button
                              isLoading
                                  ? const Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : AppTextButton(
                                      buttonText: 'Login',
                                      isNav: false,
                                      textStyle: AppStyle.font14WhiteBold,
                                      backgroundColor: AppColors.primaryColor,
                                      onPressed: login,
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
