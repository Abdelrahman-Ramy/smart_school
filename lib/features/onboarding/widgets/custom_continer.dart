import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';

class CustomContainer extends StatefulWidget {
  final String image;
  final String title;
  final String description;

  const CustomContainer({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whyColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.image),
          Gap(50.h),
          Text(widget.title, style: AppStyle.font20BlackW500),
          Gap(8.h),
          Padding(
            padding: const EdgeInsets.all(20
            ),
            child: Text(
              widget.description,
              style: AppStyle.font15GreyW500.copyWith(color: AppColors.primaryColor)
            ),
          ),
          Gap(10.h),
        ],
      ),
    );
  }
}
