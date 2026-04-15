import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/core/widgets/settings_item.dart';
import 'package:smart_school/features/parent/widgets/attendance_calendar_card.dart';
import 'package:smart_school/features/parent/widgets/custom_small_card_attend.dart';
import 'package:smart_school/features/parent/widgets/grads_card.dart';

class ParentHomeView extends StatefulWidget {
  const ParentHomeView({super.key});

  @override
  State<ParentHomeView> createState() => _ParentHomeViewState();
}

class _ParentHomeViewState extends State<ParentHomeView> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(15.h),
                Row(
                  children: [
                    Image.asset(width: 260.w, 'assets/images/logo_name.png'),
                    Gap(60.w),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(Routes.parentNotifications);
                      },
                      child: const Icon(
                        Icons.notifications_active,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                Gap(15.h),
                Text('  Welcome back!', style: AppStyle.font25BlackBold),
                Text(
                  '  Hope you and your child are\n  having a great day.☀',
                  style: AppStyle.font18GreyW500,
                ),
                Gap(10.h),
                SettingsItem(
                  icon: CupertinoIcons.person,
                  trailing: const Icon(CupertinoIcons.chevron_down),
                  title: 'Kareem Ali',
                  subtitle: '4th Garde - Section B',
                  onTap: () {},
                ),
                Gap(8.h),
                Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Attendance',
                              style: isSelected
                                  ? AppStyle.font14WhiteBold.copyWith(
                                      fontSize: 16.sp,
                                    )
                                  : AppStyle.font16BlackBold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !isSelected
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Grades',
                              style: !isSelected
                                  ? AppStyle.font14WhiteBold.copyWith(
                                      fontSize: 16.sp,
                                    )
                                  : AppStyle.font16BlackBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(15.h),
                // if()  => This can store a widget
                // ... => This can store a list
                if (isSelected) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: CustomSmallCardAttend(
                          iconData: Icons.check_circle,
                          percentage: '92',
                          text: 'Attendance rate',
                          iconColor: AppColors.greenDarkColor,
                        ),
                      ),
                      Gap(5.h),
                      const Expanded(
                        child: CustomSmallCardAttend(
                          iconData: Icons.close,
                          percentage: '8',
                          text: 'Absences',
                          iconColor: AppColors.redColor,
                        ),
                      ),
                    ],
                  ),
                  Gap(15.h),
                  const AttendanceCalendarCard(),
                ] else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Gap(10.h),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const GradsCard(
                        title: 'Math',
                        subTitle: 'Unit 3 Test',
                        percentage: '95',
                        icon: Icons.calculate_outlined,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
