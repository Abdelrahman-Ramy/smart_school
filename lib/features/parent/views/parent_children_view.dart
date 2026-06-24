import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/app_text_button.dart';
import 'package:smart_school/core/widgets/app_text_feild.dart';
import 'package:smart_school/core/widgets/custom_snackbar.dart';
import 'package:smart_school/features/parent/cubits/children_list_state.dart';
import 'package:smart_school/features/parent/cubits/parent_children_list_cubit.dart';
import 'package:smart_school/features/parent/cubits/parent_link_student_cubit.dart';
import 'package:smart_school/features/parent/cubits/parent_link_student_state.dart';

import 'package:smart_school/features/parent/data/parent_repo.dart';

class ParentChildrenView extends StatefulWidget {
  const ParentChildrenView({super.key});

  @override
  State<ParentChildrenView> createState() => _ParentChildrenViewState();
}

class _ParentChildrenViewState extends State<ParentChildrenView> {
  final TextEditingController studentIdController = TextEditingController();

  @override
  void dispose() {
    studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ParentLinkStudentCubit(ParentRepo())),
        BlocProvider(
          create: (_) => ParentChildrenListCubit(ParentRepo())..getChildren(),
        ),
      ],
      child: BlocConsumer<ParentLinkStudentCubit, ParentLinkStudentState>(
        listener: (context, state) {
          if (state is ParentLinkStudentSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                customSnackbar(
                  errorMsg: state.message,
                  icon: Icons.check,
                  color: Colors.green.shade900,
                ),
              );

            studentIdController.clear();
            context.read<ParentChildrenListCubit>().getChildren();
          }

          if (state is ParentLinkStudentError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                customSnackbar(
                  errorMsg: state.message,
                  icon: CupertinoIcons.info,
                  color: Colors.red.shade900,
                ),
              );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ParentLinkStudentCubit>();

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,

              appBar: AppBar(
                backgroundColor: AppColors.whiteColor,
                scrolledUnderElevation: 0,
                elevation: 0,
                title: Text('My Children', style: AppStyle.font22BlackW500),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.chevron_back,
                    color: AppColors.blackColor,
                    size: 26.sp,
                  ),
                ),
              ),

              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Gap(25.h),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: AppColors.glassyColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Link Student",
                            style: AppStyle.font20BlackW500.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),

                          Gap(15.h),

                          AppTextFormField(
                            hintText: "Enter Student ID",
                            controller: studentIdController,
                            keyboardType: TextInputType.text,
                            backgroundColor: AppColors.whiteColor,
                          ),

                          Gap(20.h),

                          state is ParentLinkStudentLoading
                              ? const Center(
                                  child: CupertinoActivityIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                )
                              : AppTextButton(
                                  buttonText: "Link Student",
                                  backgroundColor: AppColors.primaryColor,
                                  textStyle: AppStyle.font16BlackBold.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                  onPressed: () {
                                    if (studentIdController.text
                                        .trim()
                                        .isEmpty) {
                                      return;
                                    }

                                    cubit.linkStudent(
                                      studentId: studentIdController.text
                                          .trim(),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),

                    Gap(20.h),

                    BlocBuilder<
                      ParentChildrenListCubit,
                      ParentChildrenListState
                    >(
                      builder: (context, state) {
                        if (state is ParentChildrenListLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: CupertinoActivityIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        if (state is ParentChildrenListError) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              state.message,
                              style: const TextStyle(color: AppColors.redColor),
                            ),
                          );
                        }

                        if (state is ParentChildrenListSuccess) {
                          final children = state.children;

                          if (children.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("No children linked yet"),
                            );
                          }

                          return Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.only(bottom: 20.h),
                              itemCount: children.length,
                              separatorBuilder: (_, __) => Gap(10.h),
                              itemBuilder: (context, index) {
                                final child = children[index];

                                return Container(
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(15.r),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.2,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.primaryColor,
                                        child: Text(
                                          child.name.isNotEmpty
                                              ? child.name[0].toUpperCase()
                                              : "S",
                                          style: const TextStyle(
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ),

                                      Gap(10.w),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              child.name,
                                              style: AppStyle.font16BlackBold,
                                            ),
                                            Gap(3.h),
                                            Text(
                                              "ID: ${child.studentCode}",
                                              style: AppStyle.font13White500
                                                  .copyWith(
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                            Text(
                                              "Grade: ${child.gradeLevel}",
                                              style: AppStyle.font13White500
                                                  .copyWith(
                                                    color: Colors.black54,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // IconButton(
                                      //   onPressed: () async {
                                      //     await context
                                      //         .read<ParentChildrenListCubit>()
                                      //         .unlinkStudent(
                                      //           studentId: child.id.toString(),
                                      //         );

                                      //     if (!context.mounted) return;

                                      //     ScaffoldMessenger.of(context)
                                      //       ..hideCurrentSnackBar()
                                      //       ..showSnackBar(
                                      //         customSnackbar(
                                      //           errorMsg:
                                      //               "Child removed successfully",
                                      //           icon: Icons.check,
                                      //           color: Colors.green.shade900,
                                      //         ),
                                      //       );
                                      //   },
                                      //   icon: const Icon(
                                      //     Icons.delete,
                                      //     color: Colors.red,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
