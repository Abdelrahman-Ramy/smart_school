import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final String hintText;
  final TextEditingController controller;
  final TextStyle? hintStyle;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextInputAction? textInputAction;
  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    required this.hintText,
    required this.controller,
    this.isObscureText,
    this.suffixIcon,
    this.hintStyle,
    this.backgroundColor,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      style: const TextStyle(fontSize: 20, color: AppColors.primaryColor),
      controller: controller,
      cursorColor: Colors.blue,
      cursorWidth: 1.5,
      cursorHeight: 25,
      cursorRadius: const Radius.circular(8),
      obscureText: isObscureText ?? false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please fill $hintText';
        }
        null;
      },
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontSize: 16, color: AppColors.primaryColor),
        hintText: hintText,
        suffixIcon: suffixIcon,
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Colors.blue, width: 1.3),
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Colors.white, width: 1.3),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.3),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.3),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
        ),
      ),
    );
  }
}