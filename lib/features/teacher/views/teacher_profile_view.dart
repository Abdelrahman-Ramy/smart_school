import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/auth/data/auth_repo.dart';
import 'package:smart_school/features/auth/data/user_model.dart';

class TeacherProfileView extends StatefulWidget {
  const TeacherProfileView({super.key});

  @override
  State<TeacherProfileView> createState() => _TeacherProfileViewState();
}

class _TeacherProfileViewState extends State<TeacherProfileView> {
AuthRepo authRepo = AuthRepo();

  UserModel? userModel;

  Future<void> fetchUserData() async {
    try {
      final user = await authRepo.getProfile();

      if (mounted) {
        setState(() {
          userModel = user;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(30.h),
              buildStaticField(Icons.person_outline, 'Name',  userModel?.name?.toString() ?? 'name'),
              buildStaticField(
                Icons.phone_outlined,
                'Phone number',
                 userModel?.phone ?? '+20 123 456 7890',
              ),
              buildStaticField(Icons.email, 'email',  userModel?.email ?? 'example@gmail.com'),
              buildStaticField(
                Icons.menu_book,
                'Subject specialization',
                'Math',
              ),
              buildStaticField(Icons.group_outlined, 'Gender', 'Male'),
              buildStaticField(
                Icons.location_on_outlined,
                'Address',
                 userModel?.address?.toString() ?? 'Cairo, Egypt',
              ),
              Gap(30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStaticField(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: Colors.grey),
              Gap(10.w),
              Text(label, style: AppStyle.font15GreyW400),
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
              value,
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
