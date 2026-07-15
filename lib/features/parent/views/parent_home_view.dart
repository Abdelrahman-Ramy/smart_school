import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/helpers/extensions.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/parent/widgets/attendance_calendar_card.dart';
import 'package:smart_school/features/parent/widgets/custom_small_card_attend.dart';
import 'package:smart_school/features/parent/widgets/grads_card.dart';
import 'package:smart_school/features/parent/data/parent_profile_model.dart';
import 'package:smart_school/features/parent/data/parent_repo.dart';
import 'package:smart_school/features/parent/data/parent_attendance_model.dart';
import 'package:smart_school/features/parent/data/parent_results_model.dart';
import 'package:smart_school/features/parent/data/parent_schedule_model.dart';
import 'package:smart_school/features/notifications/widgets/notification_badge_icon.dart';

class ParentHomeView extends StatefulWidget {
  const ParentHomeView({super.key});

  @override
  State<ParentHomeView> createState() => _ParentHomeViewState();
}

class _ParentHomeViewState extends State<ParentHomeView> {
  bool isSelected = true;

  ParentUser? parentUser;
  final ParentRepo parentRepo = ParentRepo();

  List<ParentStudent> children = [];
  String? selectedStudentId;

  List<ParentAttendanceModel> attendance = [];
  List<ParentResultModel> results = [];
  List<ParentScheduleModel> schedules = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final res = await parentRepo.getProfile();

    if (!mounted) return;

    setState(() {
      parentUser = res.user;
      children = res.user.students;

      if (children.isNotEmpty) {
        selectedStudentId = children.first.studentId;
      }
    });

    if (selectedStudentId != null) {
      await loadAllData();
    }
  }

  Future<void> loadAllData() async {
    if (selectedStudentId == null) return;

    final att = await parentRepo.getAttendance(studentId: selectedStudentId);
    final res = await parentRepo.getResults(studentId: selectedStudentId);
    final sch = await parentRepo.getSchedules(studentId: selectedStudentId);

    if (!mounted) return;

    setState(() {
      attendance = att;
      results = res;
      schedules = sch;
    });
  }

  void changeStudent(String id) {
    if (!mounted) return;

    setState(() {
      selectedStudentId = id;
    });

    loadAllData();
  }

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
                Gap(8.h),
                Row(
                  children: [
                    Image.asset(width: 260.w, 'assets/images/logo_name.png'),
                    Gap(50.w),
                    NotificationBadgeIcon(
                      icon: Icons.notifications_active,
                      iconColor: AppColors.primaryColor,
                      onTap: () {
                        context.pushNamed(Routes.parentNotifications);
                      },
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

                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.glassyColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.person,
                            color: Colors.black,
                          ),
                          Gap(10.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parentUser?.name ?? 'Loading...',
                                  style: AppStyle.font16BlackBold,
                                ),
                                Text(
                                  'Parent Account',
                                  style: AppStyle.font13White500.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            CupertinoIcons.chevron_down,
                            color: Colors.transparent,
                          ),
                        ],
                      ),

                      Gap(10.h),

                      Divider(color: Colors.grey.shade300),

                      Gap(10.h),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: AppColors.glassyLightColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                          style: AppStyle.font16BlackBold,
                          value: selectedStudentId,
                          isExpanded: true,
                          underline: const SizedBox(),

                          items: children.map((child) {
                            return DropdownMenuItem<String>(
                              value: child.studentId,
                              child: Text(child.name),
                            );
                          }).toList(),

                          onChanged: (value) {
                            if (value != null) changeStudent(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Gap(10.h),

                // SettingsItem(
                //   icon: CupertinoIcons.person,
                //   trailing: const Icon(CupertinoIcons.chevron_down, color: Colors.transparent),
                //   title: parentUser?.name ?? 'Loading...',
                //   subtitle: 'Parent Account',
                //   onTap: () {

                //   },
                // ),
                Gap(8.h),

                /// TOGGLE
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
                          onTap: () => setState(() => isSelected = true),
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
                                  ? AppStyle.font14WhiteBold
                                  : AppStyle.font16BlackBold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isSelected = false),
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
                                  ? AppStyle.font14WhiteBold
                                  : AppStyle.font16BlackBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(12.h),

                if (isSelected) ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomSmallCardAttend(
                          iconData: Icons.check_circle,
                          percentage: attendance.isNotEmpty
                              ? attendance.first.present.toString()
                              : '0',
                          text: 'Attendance rate',
                          iconColor: AppColors.greenDarkColor,
                        ),
                      ),
                      Gap(5.w),
                      Expanded(
                        child: CustomSmallCardAttend(
                          iconData: Icons.close,
                          percentage: attendance.isNotEmpty
                              ? attendance.first.absent.toString()
                              : '0',
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
                    itemCount: results.length,
                    separatorBuilder: (_, __) => Gap(10.h),
                    itemBuilder: (context, index) {
                      final r = results[index];
                      return GradsCard(
                        title: r.quizTitle,
                        subTitle: r.studentCode,
                        percentage: r.score.toString(),
                        icon: Icons.menu_book_outlined,
                      );
                    },
                  ),
                ],

                Gap(20.h),

                Text('Schedule', style: AppStyle.font20BlackW500),

                Gap(10.h),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: schedules.isNotEmpty
                      ? schedules.first.schedule.length
                      : 0,
                  separatorBuilder: (_, __) => Gap(10.h),
                  itemBuilder: (context, index) {
                    final item = schedules.first.schedule[index];

                    return Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.day),
                          Text(item.subject),
                          Text('${item.startTime} - ${item.endTime}'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
