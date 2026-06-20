import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/teacher/data/teacher_class_model.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/features/teacher/widgets/custom_class_card.dart';

class ViewClassesView extends StatefulWidget {
  const ViewClassesView({super.key});

  @override
  State<ViewClassesView> createState() => _ViewClassesViewState();
}

class _ViewClassesViewState extends State<ViewClassesView> {
  final TeacherRepo _teacherRepo = TeacherRepo();
  late Future<List<TeacherClassModel>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _classesFuture = _teacherRepo.fetchTeacherClasses();
  }

  void _refreshClasses() {
    setState(() {
      _classesFuture = _teacherRepo.fetchTeacherClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('My Classes', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Gap(20.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text('All Classes', style: AppStyle.font14WhiteBold),
                ),
                Gap(10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greyVeryLightColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Academic Year: 2025/2026',
                          style: AppStyle.font14GreyW400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(20.h),
            Expanded(
              child: FutureBuilder<List<TeacherClassModel>>(
                future: _classesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    final error = snapshot.error;
                    String errorMsg = 'Something went wrong';
                    if (error is ApiError) {
                      errorMsg = error.message;
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(errorMsg, style: AppStyle.font14GreyW400),
                          Gap(10.h),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: _refreshClasses,
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final classes = snapshot.data!;

                    if (classes.isEmpty) {
                      return Center(
                        child: Text(
                          "You Don't Have Any Classes Yet",
                          style: AppStyle.font14GreyW400,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final classItem = classes[index];
                        final startTime = classItem.startTime?.substring(0, 5);
                        final endTime = classItem.endTime?.substring(0, 5);

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 20.h,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Select Action for ${classItem.subject}',
                                        style: AppStyle.font18WhiteW500.copyWith(
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Gap(20.h),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.cloud_upload,
                                          color: AppColors.primaryColor,
                                        ),
                                        title: Text(
                                          'Upload Materials',
                                          style: AppStyle.font14GreyW400.copyWith(
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                            Routes.teacherUploadMaterials,
                                            arguments: classItem.classId.toString(),
                                          );
                                        },
                                      ),
                                      const Divider(),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.task_alt,
                                          color: AppColors.primaryColor,
                                        ),
                                        title: Text(
                                          'Upload Assignment / Task',
                                          style: AppStyle.font14GreyW400.copyWith(
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                            Routes.teacherUploadTasks,
                                            arguments: {
                                              'classId': classItem.classId.toString(),
                                              'assignmentId': '',
                                            },
                                          );
                                        },
                                      ),
                                      const Divider(),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.leaderboard,
                                          color: AppColors.primaryColor,
                                        ),
                                        title: Text(
                                          'Upload Grades',
                                          style: AppStyle.font14GreyW400.copyWith(
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                            Routes.teacherUploadGrades,
                                            arguments: {
                                              'classId': classItem.classId.toString(),
                                              'students': [],
                                            },
                                          );
                                        },
                                      ),
                                      const Divider(),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.how_to_reg,
                                          color: AppColors.primaryColor,
                                        ),
                                        title: Text(
                                          'Upload Attendance',
                                          style: AppStyle.font14GreyW400.copyWith(
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushNamed(
                                            Routes.teacherUploadAttendance,
                                            arguments: classItem.classId.toString(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: CustomClassCard(
                            className: classItem.subject ?? '',
                            section: '${classItem.className} | ${classItem.day}',
                            studentCount: '32 students',
                            time: '$startTime - $endTime',
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            Gap(15.h),
          ],
        ),
      ),
    );
  }
}