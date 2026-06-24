import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/cubits/materials_cubit .dart';
import 'package:smart_school/features/student/cubits/materials_state .dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class MaterialView extends StatefulWidget {
  const MaterialView({super.key});

  @override
  State<MaterialView> createState() => _MaterialViewState();
}

class _MaterialViewState extends State<MaterialView> {
  late MaterialsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = MaterialsCubit(StudentRepo());
    cubit.getMaterials();
  }

  final List<Color> colors = [
    AppColors.blueLightColor,
    AppColors.greenLightColor,
    AppColors.orangeColor,
    AppColors.purpleColor,
    AppColors.tealColor,
    AppColors.redColor,
  ];

  // =========================
  // OPEN FILE
  // =========================
  Future<void> openFile(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open file';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Materials', style: AppStyle.font22BlackW500),
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
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          children: [
            Gap(20.h),
            Text(
              ' Check your latest educational materials\n and downloaded files :',
              style: AppStyle.font20BlackW500,
            ),
            Gap(15.h),

            Expanded(
              child: BlocBuilder<MaterialsCubit, MaterialsState>(
                bloc: cubit,
                builder: (context, state) {
                  if (state is MaterialsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryColor,),
                    );
                  }

                  if (state is MaterialsError) {
                    return Center(child: Text(state.error));
                  }

                  if (state is MaterialsLoaded) {
                    final materials = state.materials;

                    if (materials.isEmpty) {
                      return const Center(child: Text('No materials'));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 160.h),
                      itemCount: materials.length,
                      separatorBuilder: (_, _) => Gap(12.h),
                      itemBuilder: (context, index) {
                        final material = materials[index];

                        final color = colors[index % colors.length];

                        return Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 10.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                  Gap(10.w),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          material.title,
                                          style: AppStyle.font16BlackBold,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Gap(4.h),
                                        Text(
                                          material.className,
                                          style: AppStyle.font14GreyW400,
                                        ),
                                      ],
                                    ),
                                  ),

                                  Gap(10.w),

                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.doc_text,
                                    ),
                                  ),
                                ],
                              ),

                              Gap(12.h),

                              // file row (CLICKABLE)
                              GestureDetector(
                                onTap: () => openFile(material.fileUrl),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border:
                                        Border.all(color: Colors.black12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.cloud_download,
                                        color: color,
                                      ),
                                      Gap(8.w),
                                      Expanded(
                                        child: Text(
                                          material.fileUrl,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Gap(8.h),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    material.teacherName,
                                    style: AppStyle.font14GreyW400,
                                  ),
                                  Text(
                                    material.className,
                                    style: AppStyle.font14GreyW400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}