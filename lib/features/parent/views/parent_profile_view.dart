import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/parent/cubits/parent_profile_cubit.dart';
import 'package:smart_school/features/parent/cubits/parent_profile_state.dart';
import 'package:smart_school/features/parent/data/parent_repo.dart';

class ParentProfileView extends StatefulWidget {
  const ParentProfileView({super.key});

  @override
  State<ParentProfileView> createState() => _ParentProfileViewState();
}

class _ParentProfileViewState extends State<ParentProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParentProfileCubit(ParentRepo())..getProfile(),
      child: BlocBuilder<ParentProfileCubit, ParentProfileState>(
        builder: (context, state) {
          if (state is ParentProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: AppColors.primaryColor)),
            );
          }

          if (state is ParentProfileError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.whiteColor,
                scrolledUnderElevation: 0,
                elevation: 0,
                title: Text(
                  'Personal Information',
                  style: AppStyle.font22BlackW500,
                ),
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(child: Text(state.message)),
            );
          }

          if (state is ParentProfileLoaded) {
            final user = state.profile.user;

            final childName = user.students.isNotEmpty
                ? user.students.first.name
                : "No Child";

            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.whiteColor,
                scrolledUnderElevation: 0,
                elevation: 0,
                title: Text(
                  'Personal Information',
                  style: AppStyle.font22BlackW500,
                ),
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
                      buildStaticField(Icons.person_outline, 'Name', user.name ?? 'name'),
                      buildStaticField(
                        Icons.phone_outlined,
                        'Phone number of Parent',
                        user.phone ?? '+20 123 456 7890',
                      ),
                      buildStaticField(Icons.email, 'email', user.email),
                      buildStaticField(
                        Icons.child_care_rounded,
                        'Name of Child',
                        childName,
                      ),
                      buildStaticField(
                        Icons.location_on_outlined,
                        'Address',
                        user.address ?? '-',
                      ),
                      Gap(30.h),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Scaffold(body: SizedBox());
        },
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
