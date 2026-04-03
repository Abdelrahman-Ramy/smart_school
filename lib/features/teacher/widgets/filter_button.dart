import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class FilterButton extends StatefulWidget {
  final String label;
  final int index;

  const FilterButton({super.key, required this.label, required this.index});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  

  @override
  Widget build(BuildContext context) {
    int selectedFilter = 0;
    bool isSelected = selectedFilter == widget.index;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = widget.index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          widget.label,
          style: isSelected
              ? AppStyle.font14WhiteBold
              : AppStyle.font14GreyW400,
        ),
      ),
    );
    
  }
}
