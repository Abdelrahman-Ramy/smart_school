import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/views/login_view.dart';
import 'package:smart_school/features/auth/widgets/custom_selected_type.dart';
import 'package:smart_school/features/chats/services/firebase_chat_service.dart';

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
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthRepo authRepo = AuthRepo();
Future<void> signup() async { 
  if (formKey.currentState!.validate()) { 
    //  ROLE validation 
    if (selectedType == null || selectedType!.isEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        customSnackbar( 
          errorMsg: 'Please select user type', 
          icon: CupertinoIcons.info, 
          color: Colors.red, 
        ), 
      ); 
      return; 
    } 

    // PASSWORD validation 
    final password = passwordController.text.trim(); 
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).+$'); 

    if (!regex.hasMatch(password)) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        customSnackbar( 
          errorMsg: 'Password must contain uppercase & lowercase', 
          icon: CupertinoIcons.info, 
          color: Colors.red, 
        ), 
      ); 
      return; 
    } 

    if (selectedType == null || selectedType!.isEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        customSnackbar( 
          errorMsg: 'Please select user type', 
          icon: CupertinoIcons.info, 
          color: Colors.red, 
        ), 
      ); 
      return; 
    } 

    setState(() => isLoading = true); 

    try { 
      final user = await authRepo.signUp( 
        name: nameController.text.trim(), 
        email: emailController.text.trim(), 
        password: passwordController.text.trim(), 
        role: selectedType.toLowerCase(), 
        phone: phoneController.text.trim(), 
        address: addressController.text.trim(), 
      ); 

      if (user != null) { 
        ScaffoldMessenger.of(context).showSnackBar( 
          customSnackbar( 
            errorMsg: 'Register Successfully', 
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
              "createdAt": FieldValue.serverTimestamp(), 
            }); 

        await FirebaseChatService.createInitialChats(user.id.toString(), user.role ?? '');

        Future.delayed(const Duration(milliseconds: 500), () { 
          context.pushNamed(Routes.loginScreen); 
        }); 
      } 

    } catch (e) { 
      String errMsg = 'Error in Register'; 

      if (e is ApiError) { 
        errMsg = e.message; 
      } 

      ScaffoldMessenger.of(context).showSnackBar( 
        customSnackbar( 
          errorMsg: errMsg, 
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
                              isLoading
                                  ? const Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : AppTextButton(
                                      buttonText: 'Sign Up',
                                      isNav: false,
                                      textStyle: AppStyle.font14WhiteBold,
                                      backgroundColor: AppColors.primaryColor,
                                      onPressed: signup,
                                    ),
                              Gap(15.h),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Already have an account? ",
                                        style: AppStyle.font15GreyW400.copyWith(
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Login',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            context.pushNamed(Routes.loginScreen);
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
