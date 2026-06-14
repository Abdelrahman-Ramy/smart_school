import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/data/user_model.dart';

class ParentProfileView extends StatefulWidget {
  const ParentProfileView({super.key});

  @override
  State<ParentProfileView> createState() => _ParentProfileViewState();
}

class _ParentProfileViewState extends State<ParentProfileView> {
  UserModel? userModel;
  bool isLoading = false;

  AuthRepo authRepo = AuthRepo();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authRepo.getProfile();
      setState(() {
        userModel = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMsg = 'Error in Profile';
      if (e is ApiError) {
        errorMsg = e.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackbar(errorMsg: errorMsg, color: AppColors.redColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Personal Information', style: AppStyle.font22BlackW500),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(30.h),
                    buildStaticField(
                      Icons.person_outline,
                      'Name',
                      userModel?.name ?? 'Ali',
                    ),
                    buildStaticField(
                      Icons.phone_outlined,
                      'Phone number of Parent',
                      userModel?.phone ?? '+20 123 456 789',
                    ),
                    buildStaticField(
                      Icons.email,
                      'email',
                      userModel?.email ?? 'ali@gmail.com',
                    ),
                    // buildStaticField(Icons.group_outlined, 'Gender', 'Male'),
                    buildStaticField(
                      Icons.child_care_rounded,
                      'Name of Child',
                      'Moussa',
                    ),
                    buildStaticField(
                      Icons.location_on_outlined,
                      'Address',
                      userModel?.address ?? 'Cairo, Egypt',
                    ),
                    Gap(30.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildStaticField(IconData? icon, String? label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: Colors.grey),
              Gap(10.w),
              Text(label!, style: AppStyle.font15GreyW400),
            ],
          ),
          Gap(8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              value!,
              style: AppStyle.font16BlackBold.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
