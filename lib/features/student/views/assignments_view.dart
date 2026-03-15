import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/student/widgets/custom_ass_con.dart';

class AssignmentsView extends StatelessWidget {
  const AssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text('Assignments', style: AppStyle.font22BlackW500),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            color: AppColors.blackColor,
            size: 26.sp,
            CupertinoIcons.chevron_back,
          ),
        ),
      ),
      body: Column(
        children: [
          Gap(20.h),
          Expanded(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return const CustomAssCon(
                  priority: 'HIGH PRIORITY',
                  title: 'Arabic Essay',
                  progress: 'Due: Tomorrow - Not Started',
                  statusTitle: 'Instructions.pdf',
                  colorPriority: AppColors.redColor,
                  iconData: CupertinoIcons.doc_text_viewfinder,
                  status: '[Start Assignment]',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
