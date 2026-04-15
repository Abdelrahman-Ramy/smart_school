import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class AttendanceCalendarCard extends StatefulWidget {
  const AttendanceCalendarCard({super.key});

  @override
  State<AttendanceCalendarCard> createState() => _AttendanceCalendarCardState();
}

class _AttendanceCalendarCardState extends State<AttendanceCalendarCard> {
  DateTime focusedDate = DateTime.now();
  final DateTime today = DateTime.now();

  void changeWeek(int weeks) {
    DateTime newDate = focusedDate.add(Duration(days: weeks * 7));
    if (newDate.isAfter(today) && weeks > 0) return;
    setState(() => focusedDate = newDate);
  }

  List<DateTime> _getWeekDays() {
    DateTime sunday = focusedDate.subtract(
      Duration(days: focusedDate.weekday % 7),
    );
    return List.generate(5, (i) => sunday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final days = _getWeekDays();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.glassyColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => changeWeek(-1),
                icon: Icon(Icons.arrow_back_ios, size: 16.sp),
              ),
              Text(
                DateFormat('MMMM yyyy').format(focusedDate),
                style: AppStyle.font19BlackW500.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => changeWeek(1),
                icon: Icon(Icons.arrow_forward_ios, size: 16.sp),
              ),
            ],
          ),
          const Gap(15),
          Table(
            border: TableBorder.all(color: Colors.grey.shade100),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade50),
                children: days
                    .map(
                      (day) => _buildCell(
                        DateFormat('E').format(day).toUpperCase(),
                        true,
                      ),
                    )
                    .toList(),
              ),
              TableRow(
                children: days.map((day) => buildStatusCell(day)).toList(),
              ),
            ],
          ),
          const Gap(15),
          buildLegend(),
        ],
      ),
    );
  }

  Widget _buildCell(String text, bool isHeader) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Center(
        child: Text(
          text,
          style: AppStyle.font15BlackBold.copyWith(
            fontSize: isHeader ? 15.sp : 14.sp,
          ),
        ),
      ),
    );
  }

  Widget buildStatusCell(DateTime date) {
    bool isFuture = date.isAfter(today);
    bool isPresent = date.day % 3 != 0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Text(date.day.toString(), style: AppStyle.font15BlackBold),
          const Gap(4),
          Icon(
            isFuture
                ? Icons.circle_outlined
                : (isPresent ? Icons.check_circle : Icons.cancel),
            color: isFuture
                ? Colors.grey.shade200
                : (isPresent ? AppColors.greenDarkColor : AppColors.redColor),
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget buildLegend() {
    return Row(
      children: [
        _legendItem(Icons.check_circle, AppColors.greenDarkColor, "Present"),
        const Gap(15),
        _legendItem(Icons.cancel, AppColors.redColor, "Absent"),
      ],
    );
  }

  Widget _legendItem(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 30.sp),
        const Gap(4),
        Text(label, style: AppStyle.font15BlackBold.copyWith(fontSize: 12.sp)),
      ],
    );
  }
}
